/// Bym

import UIKit
import RealmSwift

protocol DataControlDelegate: AnyObject {
    func didSelectCategory()
    func didEditProduct()
    func didAddProduct()
}

final class DataControlPresenter: NSObject {
    
    /// If in edit action and user edit the category's product, this variable store the origin category to update later.
    var originCategoryId: Int?
    
    var currentCategory: Category?
    
    let categories: Results<Category>
    
    var editingProduct: Storage?
    
    let realmService: RealmService
    
    let pickerView: UIPickerView
    
    lazy var toolBar: UIToolbar = {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectCategory))
        
        doneButton.tintColor = .text
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [flexibleSpace, doneButton]
        
        return toolbar
    }()
    
    weak var delegate: DataControlDelegate?
    
    init(categories: Results<Category>, realmService: RealmService) {
        self.categories = categories
        self.realmService = realmService
        pickerView = UIPickerView()
        super.init()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc
    func selectCategory() {
        guard !categories.isEmpty else {
            delegate?.didSelectCategory()
            return
        }
        
        let row = pickerView.selectedRow(inComponent: 0)
        
        if originCategoryId == nil {
            originCategoryId = currentCategory?.id
        }
        
        currentCategory = categories[row]
        delegate?.didSelectCategory()
    }
    
    func addProduct(_ product: Storage) {
        product.id = realmService.storageAutoId + 1
        realmService.add(product, to: currentCategory)
        delegate?.didAddProduct()
    }
    
    func editProduct(_ product: Storage) {
        
        let editInfo: [String: Any?] = [
            "name": product.name,
            "price": product.price,
            "quantity": product.quantity,
            "imageData": product.imageData
        ]
        
        /// If category changed, remove this product from old category then add to new category
        if
            let originCategoryId = originCategoryId,
            let originCategory = categories.first(where: { $0.id == originCategoryId }),
            let editingProductIndex = originCategory.products.firstIndex(of: product) {
            
            /// Remove product from old category
            realmService.remove(productAt: editingProductIndex, outOf: originCategory)
            
            /// Then add to new category
            if let currentCategory = currentCategory {
                realmService.add(product, to: currentCategory)
            }
        }
        
        realmService.update(product, with: editInfo)
        delegate?.didEditProduct()
    }
}

// MARK: - PickerViewDelegate
extension DataControlPresenter: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].title
    }
}
