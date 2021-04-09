//
//  GenerationFactor.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct GenerationFactor: Decodable {
    let fuel: String
    let percentage: Float
    
    enum CodingKeys: String, CodingKey {
        case fuel
        case percentage = "perc"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fuel = try container.decode(String.self, forKey: .fuel)
        percentage = try container.decode(Float.self, forKey: .percentage)
    }
}
