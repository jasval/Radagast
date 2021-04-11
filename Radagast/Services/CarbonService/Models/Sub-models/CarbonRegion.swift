//
//  CarbonRegion.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonRegion: APIStructure {
    var isValid: Bool { true }
    
    
    let id: Float
    let dno: String
    let shortname: String
    let postcode: String?
    let intensity: CarbonIntensityForecast
    let generationMix: [GenerationFactor]
    
    enum CodingKeys: String, CodingKey {
        case id = "regionid"
        case dno = "dnoregion"
        case shortname, postcode, intensity
        case generationMix = "generationmix"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Float.self, forKey: .id)
        dno = try container.decode(String.self, forKey: .dno)
        shortname = try container.decode(String.self, forKey: .shortname)
        postcode = try container.decodeIfPresent(String.self, forKey: .postcode)
        intensity = try container.decode(CarbonIntensityForecast.self, forKey: .intensity)
        
        var generationContainer = try container.nestedUnkeyedContainer(forKey: .generationMix)
        var mix = [GenerationFactor]()
        while !generationContainer.isAtEnd {
            let generation = try generationContainer.decode(GenerationFactor.self)
            mix.append(generation)
        }
        
        generationMix = mix
    }
}
