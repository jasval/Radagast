//
//  HeaderCollectionViewCell.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit
import Charts

class HeaderCollectionViewCell: UICollectionViewCell, ShadowedCollectionCell {
    
    static let reuseIdentifier = "HeaderCollectionViewCell"
    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        return label
    }()
    
    private var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var barChart: BarChartView = {
        let view = BarChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.drawBarShadowEnabled = false
        view.drawValueAboveBarEnabled = true
        view.legend.enabled = false
        view.legend.drawInside = false
        view.highlightFullBarEnabled = false
        view.xAxis.enabled = true
        view.leftAxis.enabled = false
        view.rightAxis.enabled = false
        view.backgroundColor = .clear
        return view
    }()
        
    private var primaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    internal var shadowLayer: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Constraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    private func configureContents() {
        //Setup Views
        self.contentView.addSubview(shadowLayer)
        self.contentView.addSubview(primaryView)
        primaryView.addSubview(descriptionView)
        primaryView.addSubview(barChart)
        descriptionView.addSubview(title)

        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shadowLayer.centerXAnchor.constraint(equalTo: primaryView.centerXAnchor),
            shadowLayer.centerYAnchor.constraint(equalTo: primaryView.centerYAnchor),
            shadowLayer.heightAnchor.constraint(equalTo: primaryView.heightAnchor),
            shadowLayer.widthAnchor.constraint(equalTo: primaryView.widthAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: primaryView.topAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 10),
            descriptionView.widthAnchor.constraint(lessThanOrEqualTo: primaryView.widthAnchor, multiplier: 0.6),
            descriptionView.heightAnchor.constraint(equalToConstant: 50),
            
            title.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            title.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 0.4),
            title.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            
            barChart.topAnchor.constraint(equalTo: primaryView.topAnchor, constant: 20),
            barChart.centerXAnchor.constraint(equalTo: primaryView.centerXAnchor),
            barChart.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor, constant: -10),
            barChart.widthAnchor.constraint(equalTo: primaryView.widthAnchor, multiplier: 1)
        ])
    }
    
    //MARK: - Configure cell with data
    func configure(with data: CarbonTableViewModel.CellData) {
        title.text = data.name
        if let chartData = data.generationMix, !chartData.isEmpty {
            let values = chartData.map { Double($0.value) }
            let dataPoints = chartData.map { $0.key }
            customiseChart(dataPoints: dataPoints, values: values)
        }
    }
    
    private func customiseChart(dataPoints: [String], values: [Double]) {
        // 1. Set ChartDataEntry
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "CO2 Distribution")
            
        barChartDataSet.colors = chartColors(for: dataPoints)
        // 3. Set ChartData
        let barChartData = BarChartData(dataSet: barChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        barChart.data = barChartData
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChart.xAxis.granularity = 0.1
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelRotationAngle = 45.0
        barChart.xAxis.wordWrapEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.axisMinLabels = dataPoints.count
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.scaleXEnabled = true
        barChart.scaleYEnabled = false
        barChart.dragYEnabled = false
        barChart.xAxis.avoidFirstLastClippingEnabled = true
        barChart.xAxis.granularityEnabled = true
        
    }
    
    private func chartColors(for dataPoints: [String]) -> [UIColor] {
        var colors = [UIColor]()
        for entry in dataPoints {
            let color: UIColor
            switch entry {
            case "gas":
                color = .systemOrange
            case "coal":
                color = .systemRed
            case "biomass":
                color = .systemGreen
            case "nuclear":
                color = .systemIndigo
            case "hydro":
                color = .systemBlue
            case "storage":
                color = .systemPink
            case "imports":
                color = .systemGray2
            case "other":
                color = .systemGray
            case "wind":
                color = .systemTeal
            case "solar":
                color = .systemYellow
            default:
                color = .systemGray
            }
            colors.append(color)
        }
        return colors
    }
    
    
}
