//
//  CarbonTableViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class CarbonTableViewController: UITableViewController {
    
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 25
        self.view.layer.masksToBounds = true
        self.clearsSelectionOnViewWillAppear = false

        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        tableView.register(GraphedTableViewCell.self, forCellReuseIdentifier: GraphedTableViewCell.reuseIdentifier)
    }
    
    
}

extension CarbonTableViewController {
    
    enum Section: CaseIterable {
        case header
        case main
    }
        
    func makeDataSource() -> UITableViewDiffableDataSource<Section, CellData> {
        return UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, listItem) in
            let cell = tableView.dequeueReusableCell(withIdentifier: GraphedTableViewCell.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = "Wooho"
            return cell
//            switch listItem {
//            case .national:
//                let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//            }
        }
    }
}

extension CarbonTableViewController {
    struct CellData: Hashable {
        let name: String
        let forecasted: Float?
        let levels: Float
        let index: String
    }
    
    struct DataList {
        var national: [CellData]
        var regional: [CellData]
    }
    
    func update(with list: DataList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(list.national, toSection: .header)
        snapshot.appendItems(list.regional, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func remove(_ data: CellData, animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([data])
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
