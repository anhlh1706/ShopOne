/// Bym

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.cellId)
    }
    
    func register<T: UICollectionReusableView>(headerType: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.cellId)
    }
    
    func register<T: UICollectionReusableView>(footerType: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.cellId)
    }
    
    func dequeueReusableCell<T>(cell: T.Type = T.self, indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cell.cellId, for: indexPath) as? T else {
            fatalError("Error")
        }
        return cell
    }
    
    func dequeueReusableHeader<T>(headerType: T.Type = T.self, indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let headerView = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.cellId, for: indexPath) as? T else {
            fatalError("Error")
        }
        return headerView
    }
    
    func dequeueReusableHeader<T>(footerType: T.Type = T.self, indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let headerView = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.cellId, for: indexPath) as? T else {
            fatalError("Error")
        }
        return headerView
    }
    
}

extension UICollectionReusableView {
    
    static var cellId: String {
        return className
    }
    
    static var nib: UINib? {
        return UINib(nibName: cellId, bundle: nil)
    }
}
