//
//  CarbonCollectionViewModel.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

class CarbonCollectionViewModel {
    
    struct CellData: Hashable {
        var id: Int?
        var name: String
        var provider: String?
        var forecasted: Float?
        var levels: Float?
        var index: CarbonIntensityLevels.IntensityIndex?
        var fromTo: String?
        var lastUpdated: String
        var generationMix: [String: Float]?
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
    weak var delegate: CarbonCollectionViewController?
    
    init(_ delegate: CarbonCollectionViewController) {
        self.delegate = delegate
    }
    
    // Leveraging Bitwise Shifting
    struct DataRequestOptions: OptionSet {
        static let nationalCurrent = DataRequestOptions(rawValue: 1)
        static let allRegionCurrent = DataRequestOptions(rawValue: 1 << 1)
        static let currentGenerationMix = DataRequestOptions(rawValue: 1 << 2)
        static let all: DataRequestOptions = [.nationalCurrent, .allRegionCurrent, .currentGenerationMix]
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
                    
                case .currentGenerationMix:
                    try CarbonService.shared.getDataFor(.getCurrentNationalGeneration, completionHandler: { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonGeneration {
                            weakSelf.updateNationalModel(with: response.generationMix)
                        }
                    })
                case .all:
                    let group = DispatchGroup()
                    group.enter()
                    try CarbonService.shared.getDataFor(.getCurrentNationalForecast) { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonForecastResponse { weakSelf.updateNationalModel(with: response.data) { group.leave() }
                        }
                    }
                    try CarbonService.shared.getDataFor(.getAllRegions, completionHandler: { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonGenerationTimeFrameResponse { weakSelf.updateRegionalModels(with: response.data) { group.leave() }
                        }
                    })
                    try CarbonService.shared.getDataFor(.getCurrentNationalGeneration, completionHandler: { [weak self] (response, error) in
                        guard let weakSelf = self else { return }
                        if let error = error { print(error.localizedDescription) }
                        if let response = response as? CarbonGeneration {
                            weakSelf.updateNationalModel(with: response.generationMix) { group.leave() }
                        }
                    })
                    group.notify(queue: DispatchQueue.global()) { [weak self] in
                        guard let weakSelf = self else { return }
                        weakSelf.delegate?.update(with: weakSelf.tableData)
                    }
                default:
                    break
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateNationalModel(with collection: [CarbonForecast], fromBatchCall: Bool = false, completion: (()->())? = nil) {
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
        } else if let previousModel = tableData.national.first {
            let model = CellData(id: nil,
                                 name: "National CO2 Distribution",
                                 forecasted: data.cIntensity.forecast,
                                 levels: data.cIntensity.actual,
                                 index: data.cIntensity.index,
                                 fromTo: dateString,
                                 lastUpdated: nowString,
                                 generationMix: previousModel.generationMix)
            tableData.national[0] = model
        }
        fromBatchCall ? (completion?()) : (delegate?.update(with: tableData))
    }
    
    func updateNationalModel(with collection: [GenerationFactor]?, fromBatchCall: Bool = false, completion: (()->())? = nil) {
        guard let collection = collection else { return }
        var mix = [String: Float]()
        for factor in collection {
            mix[factor.fuel] = factor.percentage
        }
        if let previousModel = tableData.national.first {
            let model = CellData(id: nil,
                                 name: "National CO2 Distribution",
                                 forecasted: previousModel.forecasted,
                                 levels: previousModel.levels,
                                 index: previousModel.index,
                                 fromTo: previousModel.fromTo,
                                 lastUpdated: previousModel.lastUpdated,
                                 generationMix: mix)
            tableData.national[0] = model
        }
        fromBatchCall ? (completion?()) : (delegate?.update(with: tableData))
    }
    
    func updateRegionalModels(with collection: [CarbonGenerationTimeFrame], fromBatchCall: Bool = false, completion: (()->())? = nil) {
        let nowString = DateFormatter.viewReady.string(from: Date())
        for data in collection {
            let bannedRegionsFromMain: [Float]  = [15, 16, 17, 18]
            var tableDataRegional = [CellData]()
            for region in data.regions where !bannedRegionsFromMain.contains(region.id) {
                tableDataRegional.append(CellData(id: Int(region.id),
                                                  name: region.shortname,
                                                  provider: region.dno,
                                                  forecasted: region.intensity.forecast,
                                                  levels: region.intensity.actual,
                                                  index: region.intensity.index,
                                                  lastUpdated: nowString))
            }
            tableData.regional = tableDataRegional
        }
        fromBatchCall ? (completion?()) : (delegate?.update(with: tableData))
    }
    
}
