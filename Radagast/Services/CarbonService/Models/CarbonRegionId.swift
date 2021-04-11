//
//  CarbonRegionId.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonRegionId: APIResponse {
    let id: Float
    let dno: String
    let shortname: String
    let postcode: String?
    let data: [CarbonRegionIdData]
    
    enum CodingKeys: String, CodingKey {
        case id = "regionid"
        case dno = "dnoregion"
        case shortname, postcode
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Float.self, forKey: .id)
        dno = try container.decode(String.self, forKey: .dno)
        shortname = try container.decode(String.self, forKey: .shortname)
        postcode = try? container.decodeIfPresent(String.self, forKey: .postcode)
        
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var dataItems = [CarbonRegionIdData]()
        
        while !dataContainer.isAtEnd {
            let regionIdData = try dataContainer.decode(CarbonRegionIdData.self)
            dataItems.append(regionIdData)
        }
        
        data = dataItems
    }
    
    // Skip Validation
    func validate() -> Bool {
        true
    }
}

struct CarbonRegionIdResponse: APIResponse {

    let data: CarbonRegionId
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decode(CarbonRegionId.self, forKey: .data)
    }
    
    func validate() -> Bool {
        return true
    }
}
