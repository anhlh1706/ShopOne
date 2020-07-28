/// Bym

import UIKit
import RealmSwift

final class CategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories: Results<Category>
    
    let realmService: RealmService
    
    init(categories: Results<Category>, realmService: RealmService) {
        self.categories = categories
        self.realmService = realmService
        super.init(collectionViewLayout: UICollectionViewLeftAlignedLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.String.categoryTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .background
        collectionView.register(cell: CategoryCell.self)
        collectionView.register(cell: AddCategoryCell.self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Add button
        if indexPath.item == categories.count {
            let cell = collectionView.dequeueReusableCell(cell: AddCategoryCell.self, indexPath: indexPath)
            cell.button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
            return cell
        }
        
        // Categories
        let cell = collectionView.dequeueReusableCell(cell: CategoryCell.self, indexPath: indexPath)
        
        cell.configure(with: categories[indexPath.item])
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteCategory(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addCategory() {
        let alert = UIAlertController(title: R.String.addCategory, message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = R.String.category
            field.autocapitalizationType = .words
        }
        
        alert.addOkAction {
            if let title = alert.textFields?.first?.text, title.standardlized.count > 0 {
                self.realmService.add(Category(title: title))
                
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: [IndexPath(item: self.categories.count - 1, section: 0)])
                })
            }
        }
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showAlertDeleteError() {
        AlertService.show(in: self,
                          title: R.String.error,
                          msg: R.String.categoryDeleteErrorMsg)
    }
    
    fileprivate func showAlertConfirmDelete(at index: Int) {
        
        let alert = UIAlertController(title: R.String.deleteCategory(categories[index]), message: nil, preferredStyle: .alert)
        
        alert.addOkAction {
            RealmService.shared.detele(self.categories[index])
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            })
            // To refresh size for item
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.collectionView.reloadData()
            }
        }
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteCategory(sender: UIButton) {
        let index = sender.tag
        
        if categories[index].products.isEmpty {
            showAlertConfirmDelete(at: index)
        } else {
            showAlertDeleteError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == categories.count {
            return CGSize(width: 35, height: 35)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let titleWidth = (categories[indexPath.item].title as NSString).size(withAttributes: attributes).width + 40
        
        return CGSize(width: titleWidth, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach { attributesCopy.append($0.copy() as! UICollectionViewLayoutAttributes) }
        }
        
        for attributes in attributesCopy where attributes.representedElementKind == nil {
            if let attr = layoutAttributesForItem(at: attributes.indexPath) {
                attributes.frame = attr.frame
            }
        }
        return attributesCopy
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
        
        let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.width
        let currentFrame = currentItemAttributes.frame
        let strecthedCurrentFrame = CGRect(x: sectionInset.left,
                                           y: currentFrame.origin.y,
                                           width: layoutWidth,
                                           height: currentFrame.size.height)
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        if !previousFrame.intersects(strecthedCurrentFrame) {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        var frame = currentItemAttributes.frame
        frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(at: indexPath.section)
        currentItemAttributes.frame = frame
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacing(at sectionIndex: Int) -> CGFloat {
        let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        let inteitemSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
        return inteitemSpacing ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        let insetForSection = delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: index)
        return insetForSection ?? sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}
