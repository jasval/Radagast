//
//  CarbonStatistics.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonStatistics: APIStructure {

    let from: Date
    let to: Date
    let intensity: CarbonIntensityLevels
    
    enum CodingKeys: String, CodingKey {
        case from, to, intensity
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

        intensity = try container.decode(CarbonIntensityLevels.self, forKey: .intensity)
    }

    var isValid: Bool {
        return true
    }

}
