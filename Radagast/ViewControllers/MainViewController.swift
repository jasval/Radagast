//
//  MainViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let carbonTable = CarbonTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemGray
        carbonTable.view.backgroundColor = .systemPink
        self.navigationController?.navigationBar.isHidden = true
        self.add(carbonTable, constraints: [
            carbonTable.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            carbonTable.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            carbonTable.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carbonTable.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


}

