//
//  CarbonFactors.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonFactors: APIStructure {
    
    // TODO: We could use color coded labels or icons for the different values from these factors by separating them in percentiles
    let biomass, coal, dutchImports, frenchImports, irishImports, gasCombinedCycle, gasOpenCycle, hydro, nuclear, oil, other, pumpedStorage, solar, wind: Float?
    
    enum CodingKeys: String, CodingKey {
        case biomass = "Biomass"
        case coal = "Coal"
        case dutchImports = "Dutch Imports"
        case frenchImports = "French Imports"
        case irishImports = "Irish Imports"
        case gasCombinedCycle = "Gas (Combined Cycle)"
        case gasOpenCycle = "Gas (Open Cycle)"
        case hydro = "Hydro"
        case nuclear = "Nuclear"
        case oil = "Oil"
        case other = "Other"
        case pumpedStorage = "Pumped Storage"
        case solar = "Solar"
        case wind = "Wind"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        biomass = try container.decode(Float.self, forKey: .biomass)
        coal = try container.decode(Float.self, forKey: .coal)
        dutchImports = try container.decode(Float.self, forKey: .dutchImports)
        frenchImports = try container.decode(Float.self, forKey: .frenchImports)
        irishImports = try container.decode(Float.self, forKey: .irishImports)
        gasCombinedCycle = try container.decode(Float.self, forKey: .gasCombinedCycle)
        gasOpenCycle = try container.decode(Float.self, forKey: .gasOpenCycle)
        hydro = try container.decode(Float.self, forKey: .hydro)
        nuclear = try container.decode(Float.self, forKey: .nuclear)
        oil = try container.decode(Float.self, forKey: .oil)
        other = try container.decode(Float.self, forKey: .other)
        pumpedStorage = try container.decode(Float.self, forKey: .pumpedStorage)
        solar = try container.decode(Float.self, forKey: .solar)
        wind = try container.decode(Float.self, forKey: .wind)
    }
    
    var isValid: Bool {
        return true
    }
}
