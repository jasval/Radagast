//
//  CarbonGeneration.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonGeneration: APIStructure {
    let from: Date?
    let to: Date?
    let generationMix: [GenerationFactor]?
    
    enum CodingKeys: String, CodingKey {
        case from, to
        case generationMix = "generationmix"
    }
    
    enum DataKey: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        let fromDateString = try dataContainer.decode(String.self, forKey: .from)
        if let fromDate = DateFormatter.carbon.date(from: fromDateString) {
            from = fromDate
        } else {
            // Defaults to an old date to avoid null values and in case there is a problem we handle it later.
            from = Date(timeIntervalSince1970: 0)
        }
        
        let toDateString = try dataContainer.decode(String.self, forKey: .to)
        if let toDate = DateFormatter.carbon.date(from: toDateString) {
            to = toDate
        } else {
            to = Date(timeIntervalSince1970: 0)
        }
        
        var generationContainer = try dataContainer.nestedUnkeyedContainer(forKey: .generationMix)
        var mix = [GenerationFactor]()
        
        while !generationContainer.isAtEnd {
            let generation = try generationContainer.decode(GenerationFactor.self)
            mix.append(generation)
        }
        
        generationMix = mix
    }
    
    var isValid: Bool {
        true
    }

}
