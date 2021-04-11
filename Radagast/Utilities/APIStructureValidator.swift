//
//  APIStructureValidator.swift
//  Radagast
//
//  Created by Jasper Valdivia on 11/04/2021.
//

import Foundation

class APIStructureValidator {
    
    static let shared = APIStructureValidator()
    
    func isCarbonForecastResponseValid(_ response: CarbonForecastResponse) -> Bool {
        response.data.isEmpty ? false : true
    }
    
    func isCarbonForecastValid(_ forecast: CarbonForecast ) -> Bool {
        // DATE CHECKING
        if forecast.from > forecast.to { return false }
        let calendar = Calendar(identifier: .gregorian)
        if let maximumReliableAPIEstimation = calendar.date(byAdding: DateComponents(hour: 48, minute: 30), to: Date()), forecast.to > maximumReliableAPIEstimation { return false }
        
        let timeframe = forecast.from.distance(to: forecast.to)
        if timeframe != 1800 { return false }
        
        
        return true
    }
}
