//
//  RegionCollectionViewCell.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class RegionCollectionViewCell: UICollectionViewCell, ShadowedCollectionCell {
    
    static let reuseIdentifier = "RegionCollectionViewCell"
    
    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        label.numberOfLines = 1
        return label
    }()
    
    private var provider: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        label.numberOfLines = 2
        return label
    }()
    
    private var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var statisticsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emissionsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowColor = UIColor.systemGray.cgColor
        label.layer.shadowOpacity = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.getDynamicColorFor(.text)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private var emissionDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 8)
        label.textColor = .systemGray
        label.text = "gCO2/kWh"
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    private var icon: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.tintColor = .systemBackground
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var primaryView: UIView = {
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
    
    // MARK: - Constraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContents()
    }
        
    //MARK: - Layout
    private func configureContents() {
        //Setup Views
        self.contentView.addSubview(shadowLayer)
        self.contentView.addSubview(primaryView)
        primaryView.addSubview(statisticsView)
        primaryView.addSubview(descriptionView)
        descriptionView.addSubview(title)
        descriptionView.addSubview(provider)
        statisticsView.addSubview(icon)
        statisticsView.addSubview(emissionsLabel)
        statisticsView.addSubview(emissionDescription)
        
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
            descriptionView.heightAnchor.constraint(equalToConstant: 90),
            
            title.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            title.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 0.4),
            title.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            
            provider.heightAnchor.constraint(equalTo: descriptionView.heightAnchor, multiplier: 0.3),
            provider.topAnchor.constraint(equalTo: title.bottomAnchor),
            provider.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            provider.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            
            statisticsView.centerYAnchor.constraint(equalTo: primaryView.centerYAnchor),
            statisticsView.heightAnchor.constraint(equalTo: primaryView.heightAnchor),
            statisticsView.trailingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: -10),
            statisticsView.widthAnchor.constraint(equalTo: primaryView.widthAnchor, multiplier: 0.4),
            
            icon.centerYAnchor.constraint(equalTo: statisticsView.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.trailingAnchor.constraint(equalTo: statisticsView.trailingAnchor),
            
            emissionsLabel.leadingAnchor.constraint(equalTo: statisticsView.leadingAnchor),
            emissionsLabel.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -15),
            emissionsLabel.topAnchor.constraint(equalTo: icon.topAnchor),
            emissionsLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
            
            emissionDescription.leadingAnchor.constraint(equalTo: emissionsLabel.leadingAnchor),
            emissionDescription.trailingAnchor.constraint(equalTo: emissionsLabel.trailingAnchor),
            emissionDescription.topAnchor.constraint(equalTo: emissionsLabel.bottomAnchor, constant: 5),
            emissionDescription.heightAnchor.constraint(lessThanOrEqualToConstant: 20),
            emissionDescription.bottomAnchor.constraint(equalTo: icon.bottomAnchor)
            
        ])
    }
    
    //MARK: - Configure cell with data
    func configure(with data: CarbonCollectionViewModel.CellData) {
        title.text = data.name
        provider.text = data.provider
        
        if let forecasted = data.forecasted {
            emissionsLabel.text = String(forecasted)
        }
        
        var iconImage: UIImage?
        var backgroundColor: UIColor?
        switch data.index {
        case .veryHigh:
            iconImage = UIImage(systemName: "exclamationmark.shield.fill")
            backgroundColor = .systemRed
        case .high:
            iconImage = UIImage(systemName: "hand.thumbsdown.fill")
            backgroundColor = .systemOrange
        case .moderate:
            iconImage = UIImage(systemName: "eyes.inverse")
            backgroundColor = .systemYellow
        case .low:
            iconImage = UIImage(systemName: "hand.thumbsup.fill")
            backgroundColor = .systemTeal
        case .veryLow:
            iconImage = UIImage(systemName: "hand.thumbsup.fill")
            backgroundColor = .systemGreen
        case .unknown:
            iconImage = UIImage(systemName: "questionmark.circle")
            backgroundColor = .systemGray
        default:
            break
        }
        icon.image = iconImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .tile)
        icon.contentMode = .center
        icon.backgroundColor = backgroundColor
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:))))
    }
    
    @objc private func tappedIcon(_ sender: UIView) {
        icon.shake(duration: 0.5)
    }
}
