//
//  CarbonForecast.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonForecast: Decodable {
    let from: Date
    let to: Date
    let cIntensity: CarbonIntensityForecast
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case cIntensity = "intensity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let fromDateString = try container.decode(String.self, forKey: .from)
        if let fromDate = DateFormatter.carbon.date(from: fromDateString) {
            from = fromDate
        } else {
            // Defaults to an old date to avoid null values and in case there is a problem we handle it later.
            from = Date(timeIntervalSince1970: 0)
        }
        
        let toDateString = try container.decode(String.self, forKey: .to)
        if let toDate = DateFormatter.carbon.date(from: toDateString) {
            to = toDate
        } else {
            to = Date(timeIntervalSince1970: 0)
        }
        
        cIntensity = try container.decode(CarbonIntensityForecast.self, forKey: .cIntensity)
    }
    
    // Skip Validation
    func validate() -> Bool {
        true
    }

}

struct CarbonForecastResponse: APIResponse {

    let data: [CarbonForecast]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var dataCollection = [CarbonForecast]()
        while !dataContainer.isAtEnd {
            let forecast = try dataContainer.decode(CarbonForecast.self)
            dataCollection.append(forecast)
        }
        
        data = dataCollection
    }
    
    func validate() -> Bool {
        return true
    }
}
