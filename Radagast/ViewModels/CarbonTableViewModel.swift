//
//  CarbonTableViewModel.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

class CarbonTableViewModel {
    
    struct CellData: Hashable {
        var name: String
        var forecasted: Float?
        var levels: Float?
        var index: CarbonIntensityLevels.IntensityIndex?
        var fromTo: String?
        var lastUpdated: String
    }
    
    struct DataList {
        var national: [CellData]
        var regional: [CellData]
        
        init() {
            national = []
            regional = []
        }
    }

    var tableData = DataList()
    weak var delegate: CarbonTableViewController?
    
    init(_ delegate: CarbonTableViewController) {
        self.delegate = delegate
    }
    
    // Leveraging Bitwise Shifting
    struct DataRequestOptions: OptionSet {
        static let nationalCurrent = DataRequestOptions(rawValue: 1)
        static let allRegionCurrent = DataRequestOptions(rawValue: 1 << 1)
        static let all: DataRequestOptions = [.nationalCurrent, .allRegionCurrent]
        let rawValue: Int8
    }
    
    func requestData(for kinds: [DataRequestOptions]) {
        do {
            for kind in kinds {
                switch kind {
                case .nationalCurrent:
                    try CarbonService.shared.getDataFor(.getCurrentNationalForecast) { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonForecastResponse { weakSelf.updateNationalModel(with: response.data) }
                    }
                case .allRegionCurrent:
                    try CarbonService.shared.getDataFor(.getAllRegions, completionHandler: { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonGenerationTimeFrameResponse { weakSelf.updateRegionalModels(with: response.data) }
                    })
                case .all:
                    try CarbonService.shared.getDataFor(.getCurrentNationalForecast) { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonForecastResponse { weakSelf.updateNationalModel(with: response.data) }
                    }
                    try CarbonService.shared.getDataFor(.getAllRegions, completionHandler: { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonGenerationTimeFrameResponse { weakSelf.updateRegionalModels(with: response.data) }
                    })
                default:
                    break
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateNationalModel(with collection: [CarbonForecast]) {
        // Change back date into string
        guard let data = collection.first else { return }
        
        var dateString = DateFormatter.viewReady.string(from: data.from)
        dateString += " - \(DateFormatter.viewReady.string(from: data.to))"
        
        let nowString = DateFormatter.viewReady.string(from: Date())

        if tableData.national.isEmpty {
            tableData.national.append(CellData(name: "National",
                                               forecasted: data.cIntensity.forecast,
                                               levels: data.cIntensity.actual,
                                               index: data.cIntensity.index,
                                               fromTo: dateString,
                                               lastUpdated: nowString))
        } else if var model = tableData.national.first {
            model.forecasted = data.cIntensity.forecast
            model.index = data.cIntensity.index
            model.levels = data.cIntensity.actual
            model.fromTo = dateString
            model.lastUpdated = nowString
        }
        delegate?.update(with: tableData)
    }
    
    func updateRegionalModels(with collection: [CarbonGenerationTimeFrame]) {
        let nowString = DateFormatter.viewReady.string(from: Date())
        for data in collection {
            tableData.regional = data.regions.map { (region) -> CellData in

                return CellData(name: region.dno + " " + region.shortname, forecasted: region.intensity.forecast, levels: region.intensity.actual, index: region.intensity.index, lastUpdated: nowString)
            }
        }
        delegate?.update(with: tableData)
    }
}
