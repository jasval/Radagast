//
//  GraphedTableViewCell.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class GraphedTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "GraphedTableViewCell"

    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        return label
    }()
    
    private var co2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.getDynamicColorFor(.text)
        return label
    }()
    
    private var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var icon: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.tintColor = .systemBackground
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
    
    private var shadowLayer: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.masksToBounds = false
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowColor = UIColor.systemGray.cgColor
//        view.layer.shadowOpacity = 0.23
//        view.layer.shadowRadius = 4.0
        return view
    }()
        
    // MARK: - Constraints
//    var isExpanded: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    private func configureContents() {
        //Setup Views
        
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.contentView.addSubview(shadowLayer)
        self.contentView.addSubview(primaryView)
        primaryView.addSubview(title)
        primaryView.addSubview(co2Label)
        primaryView.addSubview(icon)
        
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            primaryView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            shadowLayer.centerXAnchor.constraint(equalTo: primaryView.centerXAnchor),
            shadowLayer.centerYAnchor.constraint(equalTo: primaryView.centerYAnchor),
            shadowLayer.heightAnchor.constraint(equalTo: primaryView.heightAnchor),
            shadowLayer.widthAnchor.constraint(equalTo: primaryView.widthAnchor),
//            primaryView.topAnchor.constraint(equalTo: expandableView.topAnchor),
//            primaryView.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor),
//            primaryView.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor),
            title.topAnchor.constraint(equalTo: primaryView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: primaryView.leadingAnchor, constant: 5),
            title.widthAnchor.constraint(lessThanOrEqualTo: primaryView.widthAnchor, multiplier: 0.8),
            title.heightAnchor.constraint(lessThanOrEqualTo: primaryView.heightAnchor, multiplier: 0.5),
            
            co2Label.topAnchor.constraint(equalTo: title.bottomAnchor),
            co2Label.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            co2Label.widthAnchor.constraint(equalTo: title.widthAnchor),
            co2Label.heightAnchor.constraint(lessThanOrEqualTo: primaryView.heightAnchor, multiplier: 0.4),
            co2Label.bottomAnchor.constraint(equalTo: primaryView.bottomAnchor),
            icon.centerYAnchor.constraint(equalTo: primaryView.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.trailingAnchor.constraint(equalTo: primaryView.trailingAnchor, constant: -5)
            
//            expandedView.heightAnchor.constraint(equalToConstant: 40),
//            expandedView.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor),
//            expandedView.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor),
//            expandedView.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor)
        ])
    }

    //MARK: - Configure cell with data
    func configure(with data: CarbonTableViewModel.CellData) {
        title.text = data.name
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
