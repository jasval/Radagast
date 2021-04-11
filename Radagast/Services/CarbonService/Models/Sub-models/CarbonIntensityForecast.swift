//
//  CarbonIntensityForecast.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonIntensityForecast: APIStructure {
    var isValid: Bool { true }
    
    let forecast: Float?
    let actual: Float?
    let index: CarbonIntensityLevels.IntensityIndex
        
    enum CodingKeys: String, CodingKey {
        case forecast
        case actual
        case index
    }
    
    init(forecast: Float, actual: Float, index: CarbonIntensityLevels.IntensityIndex) {
        self.forecast = forecast
        self.actual = actual
        self.index = index
    }
    
    init() {
        forecast = 0
        actual = 0
        index = .unknown
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecast = try container.decode(Float.self, forKey: .forecast)
        actual = try container.decodeIfPresent(Float.self, forKey: .actual)
        let indexString = try container.decode(String.self, forKey: .index)
        
        if let foundIndex = CarbonIntensityLevels.IntensityIndex.allCases.first(where: { $0.rawValue == indexString }) {
            index = foundIndex
        } else {
            index = .unknown
        }
    }
    

}
