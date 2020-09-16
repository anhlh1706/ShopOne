/// Bym

import UIKit.UIImage
import RealmSwift

final class Storage: Object, Product {

    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var price = 0
    @objc dynamic var quantity = 0
    @objc dynamic var imageData = Data()
    var ofCategory = LinkingObjects(fromType: Category.self, property: "products")

    override static func primaryKey() -> String {
        return "id"
    }

    func copy(with zone: NSZone? = nil) -> Storage {
        return Storage(id: id, name: name, price: price, quantity: quantity, image: image)
    }

    convenience init(id: Int, name: String, price: Int, quantity: Int, image: UIImage) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.imageData = image.pngData()!
    }
}
