//
//  CarbonService.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation
import Alamofire

final class CarbonService {
    
    typealias df = DateFormatter
    
    // MARK: - Constants
    private static let baseURLString = "https://api.carbonintensity.org.uk"
    private static let description = "Carbon Intensity API"
    
    // MARK: - Initialisation
    static let shared = CarbonService()
    private let session: Session
    
    /// Initialisation of the CIService with a custom-set Session.
    init() {
        /// Rewriting the retrylimit of the base RetryPolicy in Alamofire but maintaining both exponentialBackoffBase and exponentialBackoffScale
        /// Retryable HTTPMethods limited to GET because of the nature of the API at hand.
        /// Retryable HTTPStatusCodes include a range of sufficiently common network errors when communicating with such a simple API.
        /// - 408: Request Timeout
        /// - 409: Conflict with state of target resource
        /// - 500: Internal Server Error
        /// - 501: Not implemented this functionality
        /// - 502: Bad Gateway
        /// - 503: Service Unavailable
        /// - 504: Gateway Timeout
        let policy = RetryPolicy(retryLimit: 5,
                                 exponentialBackoffBase: 2,
                                 exponentialBackoffScale: 0.5,
                                 retryableHTTPMethods: [.get],
                                 retryableHTTPStatusCodes: [408, 409, 500, 501, 502, 503, 504],
                                 retryableURLErrorCodes: [.backgroundSessionInUseByAnotherProcess,
                                                          .badServerResponse,
                                                          .backgroundSessionWasDisconnected,
                                                          .cannotConnectToHost,
                                                          .dnsLookupFailed,
                                                          .networkConnectionLost,
                                                          .timedOut])
        
        /// If app is not connected it will resort to the cached responses
        let configuration = URLSessionConfiguration.af.default
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        
        let responseCacher = ResponseCacher(behavior: .modify { _, cachedResponse in
            let cachedMetadata = ["timestamp": Date()]
            return CachedURLResponse(response: cachedResponse.response,
                                     data: cachedResponse.data,
                                     userInfo: cachedMetadata,
                                     storagePolicy: .allowed)
        })

        /// Requests will not start immediately if completion handlers are added.
        /// A different serialisation queue-thread is provided to avoid bottlenecking when handling large amounts of data (this is clearly not the case - build for the future).
        /// No secure or sensitive data is shared between the API and the client so no serverTrustManager is needed.
        session = Session(configuration: configuration,
                          delegate: SessionDelegate(fileManager: .default),
                          rootQueue: DispatchQueue(label: "com.evgreenchargin.session.rootQueue"),
                          startRequestsImmediately: false,
                          serializationQueue: DispatchQueue(label: "com.evgreenchargin.serialisationQueue"),
                          interceptor: policy,
                          serverTrustManager: nil,
                          redirectHandler: nil,
                          cachedResponseHandler: responseCacher,
                          eventMonitors: [Logger()])
        

    }

    // MARK: - Network and Request Logger
    private class Logger: EventMonitor {
        let queue = DispatchQueue(label: "com.evgreenchargin.networkLoggerQueue")
        
        func requestDidResume(_ request: Request) {
            print("Resuming: \(request)")
        }
        
        func requestIsRetrying(_ request: Request) {
            print("Retrying: \(request)")
        }
        
        func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
            debugPrint("Finished: \(response)")
        }
    }
    
    // MARK: - Network Monitoring
    // We asume a website that is not often down.
    private let manager = NetworkReachabilityManager(host: "www.google.com")
    
    // TODO: Add notifications to inform the UI accross the app to change accordingly
    func startMonitoringNetwork() {
        manager?.startListening { status in
            switch status {
            case .notReachable:
                print("Network not reachable")
            case .reachable(_):
                print("Network is reachable")
            case .unknown:
                print("Undefined network state")
            }
        }
    }
    
    func stopMonitoringNetwork() {
        manager?.stopListening()
    }
    
    // MARK: - API Interaction
    
    // Functions
    public func getDataFor(_ router: Router, completionHandler: @escaping (APIResponse?, Error?) -> Void) throws {
        let request = try router.asURLRequest()
        switch router.decodableType {
        case .cIFactors:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonFactors.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        case .cIForecast:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonForecast.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        case .cIFStatistics:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonStatistics.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        case .cIRegionId:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonRegionId.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        case .cIRegionalTimeframe:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonGenerationTimeFrame.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        case .cIGeneration:
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: CarbonGeneration.self) { response in
                completionHandler(response.value, response.error)
                debugPrint(response.metrics ?? response.serializationDuration)
            }
        }
    }
    
    // MARK: Router
    enum Router: URLRequestConvertible {
        
        case getFactors,
             getCurrentNationalForecast,
             getTodaysNationalForecast,
             getDatedNationalForecast(Date),
             getNextDayNationalForecast(Date),
             getNextTwoDaysNationalForecast(Date),
             getDayBeforeNationalForecast(Date),
             getTimeframeNationalForecast(Date, Date),
             getNationalStatistics(Date, Date),
             getCurrentNationalGeneration,
             getDayBeforeNationalGeneration(Date),
             getTimeframeNationalGeneration(Date, Date),
             getEngland,
             getScotland,
             getWales,
             getAllRegions,
             getNextDayAllRegionsForecast(Date),
             getNextTwoDaysAllRegionsForecast(Date),
             getDayBeforeAllRegionsForecast(Date),
             getTimeframeAllRegionsForecast(Date, Date),
             getPostcode(String),
             getNextDayPostcodeForecast(String, Date),
             getNextTwoDaysPostcodeForecast(String, Date),
             getDayBeforePostcodeForecast(String, Date),
             getTimeframePostcodeForecast(String, Date, Date),
             getRegionId(String),
             getNextDayRegionForecast(String, Date),
             getNextTwoDaysRegionForecast(String, Date),
             getDayBeforeRegionForecast(String, Date),
             getTimeframeRegionForecast(String, Date, Date)
        
        var baseURL: URL {
            if let url = URL(string: baseURLString) {
                return url
            } else {
                fatalError("The base endpoint url '\(CarbonService.baseURLString)' of '\(CarbonService.description)' is not valid.")
            }
        }
        
        enum DecodableType {
            case cIFactors
            case cIForecast
            case cIFStatistics
            case cIGeneration
            case cIRegionalTimeframe
            case cIRegionId
        }
        
        var decodableType: DecodableType {
            switch self {
            case .getFactors:
                return .cIFactors
            case .getCurrentNationalForecast, .getTodaysNationalForecast, .getDatedNationalForecast, .getNextDayNationalForecast, .getNextTwoDaysNationalForecast, .getDayBeforeNationalForecast, .getTimeframeNationalForecast:
                return .cIForecast
            case .getNationalStatistics:
                return .cIFStatistics
            case .getCurrentNationalGeneration, .getDayBeforeNationalGeneration, .getTimeframeNationalGeneration:
                return .cIGeneration
            case .getAllRegions, .getEngland, .getScotland, .getWales, .getNextDayAllRegionsForecast, .getNextTwoDaysAllRegionsForecast, .getDayBeforeAllRegionsForecast, .getTimeframeAllRegionsForecast:
                return .cIRegionalTimeframe
            case .getPostcode, .getRegionId, .getNextDayPostcodeForecast, .getNextTwoDaysPostcodeForecast, .getDayBeforePostcodeForecast, .getTimeframePostcodeForecast, .getNextDayRegionForecast, .getNextTwoDaysRegionForecast, .getDayBeforeRegionForecast, .getTimeframeRegionForecast:
                return .cIRegionId
            }
        }

        /// Defaultst to GET being the only one supported by this API
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            switch self {
            case .getFactors:
                return "/intensity/factors"
            case .getCurrentNationalForecast:
                return "/intensity"
            case .getTodaysNationalForecast:
                return "/intensity/date"
            case .getDatedNationalForecast(let date):
                return "/intensity/date/\(df.standard.string(from: date))"
            case .getNextDayNationalForecast(let date):
                return "/intensity/date/\(df.carbon.string(from: date))/fw24h"
            case .getNextTwoDaysNationalForecast(let date):
                return "/intensity/date/\(df.carbon.string(from: date))/fw48h"
            case .getDayBeforeNationalForecast(let date):
                return "/intensity/date/\(df.carbon.string(from: date))/pt24h"
            case .getTimeframeNationalForecast(let fromDate, let toDate):
                return "/intensity/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))"
            case .getNationalStatistics(let fromDate, let toDate):
                return "/intensity/stats/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))"
            case .getCurrentNationalGeneration:
                return "/generation"
            case .getDayBeforeNationalGeneration(let date):
                return "/generation/\(df.carbon.string(from: date))/pt24h"
            case .getTimeframeNationalGeneration(let fromDate, let toDate):
                return "/generation/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))"
            case .getEngland:
                return "/regional/england"
            case .getScotland:
                return "/regional/scotland"
            case .getWales:
                return "/regional/wales"
            case .getAllRegions:
                return "/regional"
            case .getNextDayAllRegionsForecast(let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw24h"
            case .getNextTwoDaysAllRegionsForecast(let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw48h"
            case .getDayBeforeAllRegionsForecast(let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/pt24h"
            case .getTimeframeAllRegionsForecast(let fromDate, let toDate):
                return "/regional/intensity/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))"
            case .getPostcode(let code):
                return "/regional/postcode/\(code)"
            case .getNextDayPostcodeForecast(let code, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw24h/postcode/\(code)"
            case .getNextTwoDaysPostcodeForecast(let code, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw48h/postcode/\(code)"
            case .getDayBeforePostcodeForecast(let code, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/pt24h/postcode/\(code)"
            case .getTimeframePostcodeForecast(let code, let fromDate, let toDate):
                return "/regional/intensity/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))/postcode/\(code)"
            case .getRegionId(let id):
                return "/regional/regionid/\(id)"
            case .getNextDayRegionForecast(let id, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw24h/regionid/\(id)"
            case .getNextTwoDaysRegionForecast(let id, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/fw48h/regionid/\(id)"
            case .getDayBeforeRegionForecast(let id, let date):
                return "/regional/intensity/\(df.carbon.string(from: date))/pt24h/regionid/\(id)"
            case .getTimeframeRegionForecast(let id, let fromDate, let toDate):
                return "/regional/intensity/\(df.carbon.string(from: fromDate))/\(df.carbon.string(from: toDate))/regionid/\(id)"
            }
        }
        
        var baseHeaders: HTTPHeaders {
            [HTTPHeader.accept("application/json")]
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.method = method
            request.headers = baseHeaders
            return request
        }
        
    }
    
}
