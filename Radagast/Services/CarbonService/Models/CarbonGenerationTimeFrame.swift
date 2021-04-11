//
//  CarbonGenerationTimeFrame.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

struct CarbonGenerationTimeFrame: Decodable {
    let from: Date
    let to: Date
    let regions: [CarbonRegion]
    
    enum CodingKeys: String, CodingKey {
        case from, to, regions
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

        var regionsContainer = try container.nestedUnkeyedContainer(forKey: .regions)
        var regionsCollection = [CarbonRegion]()
        
        while !regionsContainer.isAtEnd {
            let region = try regionsContainer.decode(CarbonRegion.self)
            regionsCollection.append(region)
        }
        
        regions = regionsCollection
    }
    
    // Skip Validation
    func validate() -> Bool {
        true
    }
}

struct CarbonGenerationTimeFrameResponse: APIResponse {
    let data: [CarbonGenerationTimeFrame]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var dataCollection = [CarbonGenerationTimeFrame]()
        while !dataContainer.isAtEnd {
            let regionalTimeFrame = try dataContainer.decode(CarbonGenerationTimeFrame.self)
            dataCollection.append(regionalTimeFrame)
        }
        
        data = dataCollection
    }
    
    func validate() -> Bool {
        return true
    }

}
