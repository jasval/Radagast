//
//  MainViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var carbonCollection = CarbonCollectionViewController { [weak self] (isTransitioning) in
        self?.button.isEnabled = !isTransitioning
        if isTransitioning {
            self?.button.isEnabled = false
            self?.button.backgroundColor = .systemGray
        } else {
            self?.button.isEnabled = true
            self?.button.backgroundColor = UIColor.getDynamicColorFor(.buttonBackground)
        }
    }
    
    let headerTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carbon Tracker"
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textAlignment = .left
        label.textColor = UIColor.getDynamicColorFor(.text)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.getDynamicColorFor(.buttonBackground)
        button.setTitle("Refresh".uppercased(), for: .normal)
        button.setTitle("Loading...", for: .disabled)
        button.setTitleColor(UIColor.getDynamicColorFor(.buttonText), for: .normal)
        button.setTitleColor(.black, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(refreshTapped(_:)), for: .touchUpInside)
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
        
        // Add ViewControllers
        self.add(carbonCollection, constraints: [
            carbonCollection.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            carbonCollection.view.widthAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            carbonCollection.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add Views
        view.addSubview(headerTitleLabel)
        view.addSubview(button)
        
        // Layout Views
        NSLayoutConstraint.activate([
            carbonCollection.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: view.safeAreaLayoutGuide.layoutFrame.height * 0.1),
            
            headerTitleLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            headerTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            headerTitleLabel.bottomAnchor.constraint(equalTo: carbonCollection.view.topAnchor, constant: -10),
            headerTitleLabel.widthAnchor.constraint(equalTo: carbonCollection.view.widthAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: carbonCollection.view.leadingAnchor, constant: 10),
            
            button.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            button.topAnchor.constraint(equalToSystemSpacingBelow: carbonCollection.view.bottomAnchor, multiplier: 1.5),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.widthAnchor.constraint(greaterThanOrEqualTo: carbonCollection.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc func refreshTapped(_ sender: UIButton) {
        carbonCollection.viewModel.requestData(for: [.all])
        UIView.animate(withDuration: 0.2,
            animations: { [weak self] in
                self?.button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self?.button.transform = CGAffineTransform(translationX: 0, y: 5)
            },
            completion: { [weak self] _ in
                UIView.animate(withDuration: 0.2) {
                    self?.button.transform = CGAffineTransform.identity
                }
            })

    }
}

