//
//  CarbonCollectionViewController.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

class CarbonCollectionViewController: UICollectionViewController {
    
    private lazy var dataSource = makeDataSource()
    lazy var viewModel = CarbonCollectionViewModel(self)
    
    private var isTransitioning: Bool = false {
        didSet {
            isTransitioningCallBack?(isTransitioning)
        }
    }
    private var isTransitioningCallBack: ((Bool) -> ())?
    
    init(_ interactionCallback: ((Bool) -> Void)? = nil ) {
        super.init(collectionViewLayout: UICollectionViewLayout())
        isTransitioningCallBack = interactionCallback
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 8
        self.view.layer.masksToBounds = true
        self.clearsSelectionOnViewWillAppear = false

        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier)
        collectionView.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        configureLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.requestData(for: [.all])
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
}

extension CarbonCollectionViewController {
    
    enum Section: Int, CaseIterable {
        case header
        case main
    }
        
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, CarbonCollectionViewModel.CellData> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier, for: indexPath) as? HeaderCollectionViewCell {
                    cell.configure(with: listItem)
                    return cell
                }
            case 1:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.reuseIdentifier, for: indexPath) as? RegionCollectionViewCell {
                    cell.configure(with: listItem)
                    return cell
                }
            default:
                break
            }
            return UICollectionViewCell()
        }
    }
    
    private func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            guard let sectionLayout = Section(rawValue: sectionIndex) else { return nil }
            switch sectionLayout {
            case .header: return self.headerLayoutSection()
            case .main: return self.mainLayoutSection()
            }
        }
    }
    
    private func headerLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
     .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
     .fractionalWidth(1))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
    
    private func mainLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
     heightDimension: .absolute(100))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
     heightDimension: .estimated(500))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
      section.contentInsets.leading = 10
        section.contentInsets.trailing = 10

      return section
    }
}

extension CarbonCollectionViewController {
    
    func update(with list: CarbonCollectionViewModel.DataList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CarbonCollectionViewModel.CellData>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(list.national, toSection: .header)
        snapshot.appendItems(list.regional, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func remove(_ data: CarbonCollectionViewModel.CellData, animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([data])
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}


extension CarbonCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard !isTransitioning else { return }
        switch indexPath.section {
        case Section.main.rawValue:
            isTransitioning = true
            guard let cell = collectionView.cellForItem(at: indexPath) as? ShadowedCollectionCell else { return }
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                cell.transform = CGAffineTransform(translationX: 0, y: 5)
                cell.shadowLayer.alpha = 0.0
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform.identity
                    cell.shadowLayer.alpha = 1.0
                } completion: { [weak self] _ in
                    guard let weakSelf = self, let regionId = weakSelf.viewModel.tableData.regional[indexPath.row].id else { return }
                    weakSelf.navigationController?.pushViewController(RegionDetailViewController(regionId), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        weakSelf.isTransitioning = false
                    }
                }
            }
        default:
            return
        }
    }
}
