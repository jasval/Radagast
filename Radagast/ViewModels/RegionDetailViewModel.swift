//
//  RegionDetailViewModel.swift
//  Radagast
//
//  Created by Jasper Valdivia on 10/04/2021.
//

import Foundation

class RegionDetailViewModel {
    
    init(with id: Int, callback: (()->())? = nil) {
        self.callback = callback
        self.getRegionalData(with: id)
    }
        
    var regionData: RegionData? {
        didSet {
            print(regionData.debugDescription)
            print()
        }
    }
    
    var dataSnapshots: [DataSnapshot]?
    
    let callback: (() -> ())?
    
    private func getRegionalData(with id: Int) {
        do {
            try CarbonService.shared.getDataFor(.getNextDayRegionForecast(String(id), Date()), completionHandler: { [weak self] (response, error) in
                guard let weakSelf = self else { return }
                if let error = error { print(error.localizedDescription) }
                if let response = response as? CarbonRegionIdResponse { weakSelf.updateData(with: response.data) }

            })
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    struct DataSnapshot {
        let date: String
        let levels: Double
    }
    
    struct RegionData {
        let name: String
        let dno: String
    }
    
    private func updateData(with data: CarbonRegionId) {
        
        regionData = RegionData(name: data.shortname,
                                dno: data.dno)
        var snaps = [DataSnapshot]()
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        for carbonData in data.data {
            let dateString = df.string(from: carbonData.to)
            snaps.append(DataSnapshot(date: dateString,
                                              levels: Double(carbonData.intensity.forecast ?? 0.0)))
        }
        dataSnapshots = snaps
        callback?()
    }
    
}
