//
//  CarbonService.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation
import Alamofire

final class CarbonService {
    
    // MARK: - Constants
    private static let baseURLString = "https://api.carbonintensity.org.uk"
    private static let description = "Carbon Intensity API"
    
    static let shared = CarbonService()
    
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
    
}
