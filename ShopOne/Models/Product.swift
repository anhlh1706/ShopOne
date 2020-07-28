/// Bym

import UIKit.UIImage
import RealmSwift

protocol Product: Object {
    
    var id: Int { get }
    
    var name: String { get set }
    
    var price: Int { get set }
    
    var quantity: Int { get set }
    
    var ofCategory: LinkingObjects<Category> { get }
    
    var imageData: Data { get set }
    
    var image: UIImage { get }
    
    var billing: Int { get }
    
    var priceStr: String { get }
    
    var quantityStr: String { get }
    
    var billingStr: String { get }
    
    var categoryStr: String { get }
}

extension Product {
    
    var billing: Int {
        return price * quantity
    }
    
    var image: UIImage {
        return UIImage(data: imageData)!
    }
    
    var ofCategory: LinkingObjects<Category> {
        return LinkingObjects(fromType: Category.self, property: "products")
    }
    
    var priceStr: String {
        price.addedSeparator()
    }
    
    var quantityStr: String {
        quantity.addedSeparator()
    }
    
    var billingStr: String {
        billing.addedSeparator()
    }
    
    var categoryStr: String {
        ofCategory.first?.title ?? ""
    }
}
