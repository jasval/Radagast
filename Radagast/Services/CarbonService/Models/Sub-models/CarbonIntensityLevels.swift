//
//  CarbonIntensityLevels.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonIntensityLevels: APIStructure {
    var isValid: Bool { true }
    
    
    let max, average, min: Float
    let index: IntensityIndex
    
    enum CodingKeys: String, CodingKey {
        case max, average, min, index
    }
    
    enum IntensityIndex: String, CaseIterable {
        case veryLow = "very low"
        case low = "low"
        case moderate = "moderate"
        case high = "high"
        case veryHigh = "very high"
        case unknown
        
        var string: String {
            self.rawValue.capitalized
        }
    }
    
    init(max: Float, average: Float, min: Float, index: IntensityIndex) {
        self.max = max
        self.average = average
        self.min = min
        self.index = index
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        max = try container.decode(Float.self, forKey: .max)
        min = try container.decode(Float.self, forKey: .min)
        average = try container.decode(Float.self, forKey: .average)
        
        let indexString = try container.decode(String.self, forKey: .index)
        
        if let foundIndex = IntensityIndex.allCases.first(where: {$0.rawValue == indexString}) {
            index = foundIndex
        } else {
            index = .unknown
        }
    }
}
