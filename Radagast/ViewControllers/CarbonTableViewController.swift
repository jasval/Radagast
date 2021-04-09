//
//  CarbonTableViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class CarbonTableViewController: UITableViewController {
    
    private lazy var dataSource = makeDataSource()
    lazy var viewModel = CarbonTableViewModel(self)

    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 25
        self.view.layer.masksToBounds = true
        self.clearsSelectionOnViewWillAppear = false

        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        tableView.register(GraphedTableViewCell.self, forCellReuseIdentifier: GraphedTableViewCell.reuseIdentifier)
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.requestData(for: [.all])
        }
    }
    
    
}

extension CarbonTableViewController {
    
    enum Section: CaseIterable {
        case header
        case main
    }
        
    func makeDataSource() -> UITableViewDiffableDataSource<Section, CarbonTableViewModel.CellData> {
        return UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, listItem) in
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseIdentifier, for: indexPath)
                cell.textLabel?.text = listItem.name
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: GraphedTableViewCell.reuseIdentifier, for: indexPath)
                cell.textLabel?.text = listItem.name
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

extension CarbonTableViewController {
    
    func update(with list: CarbonTableViewModel.DataList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CarbonTableViewModel.CellData>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(list.national, toSection: .header)
        snapshot.appendItems(list.regional, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func remove(_ data: CarbonTableViewModel.CellData, animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([data])
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}


extension CarbonTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
