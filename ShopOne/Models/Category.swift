// Bym

import Foundation
import RealmSwift

final class Category: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    let products = List<Storage>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int = 0, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}
