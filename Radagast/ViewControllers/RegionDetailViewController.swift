//
//  RegionDetailViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit
import Charts

class RegionDetailViewController: UIViewController {

    var viewModel: RegionDetailViewModel?
    
    private var bigCellView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var shadowLayer: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var regionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textAlignment = .left
        label.textColor = UIColor.getDynamicColorFor(.text)
        return label
    }()
    
    private var providerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        label.text = " ~ "
        label.numberOfLines = 2
        return label
    }()
    
    private var lineChartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(_ regionId: Int) {
        super.init(nibName: nil, bundle: nil)
        viewModel = RegionDetailViewModel(with: regionId) { [weak self] in
            guard let weakSelf = self else { return }
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowAnimatedContent, .curveLinear]) {
                weakSelf.regionNameLabel.text = weakSelf.viewModel?.regionData?.name
                weakSelf.providerLabel.text = weakSelf.viewModel?.regionData?.dno
                if let snaps = weakSelf.viewModel?.dataSnapshots {
                    weakSelf.customiseChart(snaps: snaps)
                    weakSelf.lineChartView.animate(xAxisDuration: 3)
                }
            } completion: { _ in
                generator.notificationOccurred(.success)
            }

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViews() {
        view.addSubview(shadowLayer)
        view.addSubview(bigCellView)
        bigCellView.addSubview(regionNameLabel)
        bigCellView.addSubview(providerLabel)
        bigCellView.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            bigCellView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            bigCellView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bigCellView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigCellView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            shadowLayer.heightAnchor.constraint(equalTo: bigCellView.heightAnchor),
            shadowLayer.widthAnchor.constraint(equalTo: bigCellView.widthAnchor),
            shadowLayer.centerXAnchor.constraint(equalTo: bigCellView.centerXAnchor),
            shadowLayer.centerYAnchor.constraint(equalTo: bigCellView.centerYAnchor),
            
            regionNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: bigCellView.topAnchor, multiplier: 2),
            regionNameLabel.leadingAnchor.constraint(equalTo: bigCellView.leadingAnchor, constant: 20),
            regionNameLabel.widthAnchor.constraint(equalTo: bigCellView.widthAnchor, multiplier: 0.9),
            regionNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            providerLabel.topAnchor.constraint(equalToSystemSpacingBelow: regionNameLabel.bottomAnchor, multiplier: 1),
            providerLabel.leadingAnchor.constraint(equalTo: regionNameLabel.leadingAnchor),
            providerLabel.widthAnchor.constraint(equalTo: bigCellView.widthAnchor, multiplier: 0.9),
            providerLabel.heightAnchor.constraint(equalToConstant: 30),
            
            lineChartView.topAnchor.constraint(equalToSystemSpacingBelow: providerLabel.bottomAnchor, multiplier: 2),
            lineChartView.leadingAnchor.constraint(equalTo: bigCellView.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: bigCellView.trailingAnchor, constant: -20),
            lineChartView.bottomAnchor.constraint(equalTo: bigCellView.bottomAnchor, constant: -20)
        ])
    }
    
    private func customiseChart(snaps: [RegionDetailViewModel.DataSnapshot]) {
        lineChartView.legend.enabled = false
        lineChartView.xAxis.labelRotationAngle = 0.0
        lineChartView.xAxis.axisLineWidth = 3
        // 1. Set ChartDataEntry
        var lineChartEntries: [ChartDataEntry] = []
        var values = [Double]()
        var dateValues = [String]()
        for i in 0..<snaps.count {
            let value = snaps[i].levels
            let dateValue = snaps[i].date
            let dataEntry = ChartDataEntry(x: Double(i), y: value, data: dateValue as AnyObject)
            values.append(value)
            dateValues.append(dateValue)
            lineChartEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let line = LineChartDataSet(entries: lineChartEntries, label: "Forecast CO2 Emissions")
        let colors = chartColors(for: values)
        let labelColor = UIColor.getDynamicColorFor(.text)
        line.circleHoleColor = UIColor.clear
        line.circleRadius = 5
        line.circleColors = colors
        line.colors = colors
        line.valueColors = [labelColor]
        line.valueFont = UIFont.systemFont(ofSize: 10, weight: .medium)
        // 3. Set ChartData
        let lineChartData = LineChartData(dataSet: line)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        lineChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        lineChartView.data = lineChartData
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateValues)
    }
    
    private func chartColors(for values: [Double]) -> [UIColor] {
        return values.map { (value) -> UIColor in
            switch value {
            case 0...150:
                return .systemGreen
            case 150...250:
                return .systemYellow
            case 250...360:
                return .systemOrange
            case 360...:
                return .systemRed
            default:
                return .systemGray
            }
        }
    }

}
