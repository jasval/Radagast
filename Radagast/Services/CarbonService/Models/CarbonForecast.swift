//
//  CarbonForecast.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonForecast: APIStructure {
    let from: Date
    let to: Date
    let intensity: CarbonIntensityForecast
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case cIntensity = "intensity"
    }
    
    /// Method with DI for TDD
    /// - Parameters:
    ///   - from: from date
    ///   - to: to date
    ///   - intensity: intensity struct with forecasting values
    init(from: Date, to: Date, intensity: CarbonIntensityForecast) {
        self.from = from
        self.to = to
        self.intensity = intensity
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
        
        intensity = try container.decode(CarbonIntensityForecast.self, forKey: .cIntensity)
    }
    
    var isValid: Bool {
        APIStructureValidator.shared.isCarbonForecastValid(self)
    }

}

struct CarbonForecastResponse: APIStructure {

    let data: [CarbonForecast]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    /// Method with DI for TDD
    /// - Parameter data: data containing CarbonForecast structs
    init(data: [CarbonForecast]) {
        self.data = data
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
    
    var isValid: Bool {
        APIStructureValidator.shared.isCarbonForecastResponseValid(self)
    }
    
}
