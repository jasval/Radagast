//
//  MainViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let carbonTable = CarbonTableViewController()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carbon Tracker"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.textColor = UIColor.getDynamicColorFor(.text)
        label.shadowColor = UIColor.systemGray2
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.getDynamicColorFor(.buttonBackground)
        button.setTitle("Refresh".uppercased(), for: .normal)
        button.setTitleColor(UIColor.getDynamicColorFor(.buttonText), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        //Navigation bar customisation
        self.navigationController?.navigationBar.isHidden = true
        
        // Colouring
        self.view.backgroundColor = .systemBackground
        carbonTable.view.backgroundColor = UIColor.getDynamicColorFor(.background)

        // Add ViewControllers
        self.add(carbonTable, constraints: [
            carbonTable.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            carbonTable.view.widthAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            carbonTable.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add Views
        view.addSubview(headerTitleLabel)
        view.addSubview(button)
        
        // Layout Views
        NSLayoutConstraint.activate([
            carbonTable.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: view.safeAreaLayoutGuide.layoutFrame.height * 0.1),
            
            headerTitleLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            headerTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            headerTitleLabel.bottomAnchor.constraint(equalTo: carbonTable.view.topAnchor, constant: -10),
            headerTitleLabel.widthAnchor.constraint(equalTo: carbonTable.view.widthAnchor),
            headerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            button.topAnchor.constraint(equalToSystemSpacingBelow: carbonTable.view.bottomAnchor, multiplier: 1.5),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.widthAnchor.constraint(greaterThanOrEqualTo: carbonTable.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }


}

