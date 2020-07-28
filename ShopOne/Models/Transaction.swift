/// Bym

import UIKit.UIImage
import RealmSwift

final class Transaction: Object, Product {
    
    @objc dynamic var transactionId = 0
    
    @objc dynamic var id = 0
    
    @objc dynamic var name = ""
    
    @objc dynamic var price = 0
    
    @objc dynamic var quantity = 0
    
    @objc dynamic var categoryName = ""
    
    @objc dynamic var imageData = Data()
    
    @objc dynamic var sellDate = Date()
    
    override class func primaryKey() -> String? {
        return "transactionId"
    }
    
    var sellDateStr: String {
        DateFormatter.dateTimeStyle().string(from: sellDate)
    }
    
    func copy(with zone: NSZone? = nil) -> Transaction {
        return Transaction(id: id, name: name, price: price, quantity: quantity, categoryName: categoryName, image: image, transactionId: transactionId, sellDate: sellDate)
    }
    
    convenience init(id: Int, name: String, price: Int, quantity: Int, categoryName: String, image: UIImage, transactionId: Int, sellDate: Date) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.categoryName = categoryName
        self.imageData = image.pngData()!
        self.transactionId = transactionId
        self.sellDate = sellDate
    }
    
    convenience init(storage: Storage) {
        self.init()
        id = storage.id
        name = storage.name
        price = storage.price
        quantity = storage.quantity
        categoryName = storage.ofCategory.first?.title ?? ""
        imageData = storage.image.pngData()!
        transactionId = 0
        sellDate = Date()
    }
}
