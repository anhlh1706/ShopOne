/// Bym

import UIKit
import RealmSwift
import Anchorage

fileprivate typealias StorageDataSource = UICollectionViewDiffableDataSource<Category, Storage>
fileprivate typealias StorageSnapshot = NSDiffableDataSourceSnapshot<Category, Storage>

final class StorageViewController: UIViewController {
    
    private lazy var noDataView = NoDataView(text: R.String.nothingHappened)
    
    private var collectionView: UICollectionView!
    
    private var dataSource: StorageDataSource!
    
    private var notificationToken: NotificationToken?
    
    lazy var subPresenter = DataControlPresenter(categories: presenter.categories, realmService: presenter.realmService)
    
    let presenter: StoragePresenter
    
    init(presenter: StoragePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.String.storageTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showAddAction))
        
        addObserver()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
}

// MARK: - Private functions
private extension StorageViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .background
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.register(cell: StorageCell.self)
        collectionView.register(headerType: StorageSectionHeaderView.self)
    }
    
    func addObserver() {
        notificationToken = presenter.categories.observe { [weak self] _ in
            self?.reloadData()
            self?.collectionView.reloadData()
        }
    }
    
    /// Update info from database, then update view.
    @objc
    func reloadData() {
        presenter.categories.allSatisfy({ $0.products.isEmpty }) ? showNoDataView() : hideNoDataView()
        
        var snapshot = StorageSnapshot()
        
        for category in presenter.categories where !category.products.isEmpty {
            snapshot.appendSections([category])
            snapshot.appendItems(category.products.map { $0 }, toSection: category)
        }
        
        if !snapshot.itemIdentifiers.isEmpty {
            dataSource?.apply(snapshot)
        } else {
            dataSource.apply(StorageSnapshot())
        }
    }
    
    /// Show DataControlViewController with edit action when select edit from ContextMenu's CollectionView
    func toEdit(at indexPath: IndexPath) {
        let actionVC = DataControlViewController(presenter: subPresenter, action: .edit(product: dataSource.itemIdentifier(for: indexPath)!))
        present(actionVC, animated: true)
    }
    
    @objc
    func showAddAction() {
        let controlVC = DataControlViewController(presenter: subPresenter, action: .add)
        present(controlVC, animated: true)
    }
    
    func showNoDataView() {
        if !view.subviews.contains(noDataView) {
            view.addSubview(noDataView)
            noDataView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
        }
    }
    
    func hideNoDataView() {
        if view.subviews.contains(noDataView) {
            noDataView.removeFromSuperview()
        }
    }
}

// MARK: - CollectionView Configuration
private extension StorageViewController {
    
    /// Configure DataSource including cell and header view for collectionView
    func createDataSource() {
        
        dataSource = StorageDataSource(collectionView: collectionView) { collectionView, indexPath, storage in
            let cell = collectionView.dequeueReusableCell(cell: StorageCell.self, indexPath: indexPath)
            cell.configure(product: storage)
            
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let category = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            let categoryHeader = collectionView.dequeueReusableHeader(headerType: StorageSectionHeaderView.self, indexPath: indexPath)
            
            categoryHeader.title.text = category.title
            return categoryHeader
        }
    }
    
    /// Configure flow layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(using: self.presenter.categories[sectionIndex])
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    /// Configure section layout
    func createSection(using category: Category) -> NSCollectionLayoutSection {
        
        let itemSize: NSCollectionLayoutSize
        let layoutGroupSize: NSCollectionLayoutSize

        switch category.products.count {
        case 1:
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(80))
        case 2:
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(160))
        default:
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
            layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(240))
        }

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }
    
    /// Configure section header layout.
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

// MARK: - UICollectionViewDelegate
extension StorageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: R.String.edit, image: UIImage(systemName: "arrow.counterclockwise")) { _ in
                self.toEdit(at: indexPath)
            }
            
            let deleteAction = UIAction(title: R.String.delete, image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: {_ in
                self.delete(at: indexPath)
            })
            
            return UIMenu(title: R.String.options, children: [editAction, deleteAction])
        }
    }
    
    /// Delete object when select delete action from ContextMenu's CollectionView
    func delete(at indexPath: IndexPath) {
        if
            let storage = dataSource.itemIdentifier(for: indexPath),
            let category = dataSource.snapshot().sectionIdentifier(containingItem: storage),
            let indexOfStorage = category.products.firstIndex(of: storage) {
            
            try! presenter.realmService.realm.write {
                category.products.remove(at: indexOfStorage)
            }
            reloadData()
        }
    }
    
}
