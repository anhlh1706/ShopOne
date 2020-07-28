/// Bym

import Foundation
import RealmSwift

final class StoragePresenter {
    
    let realmService: RealmService
    
    var categories: Results<Category>!
    
    init(realmService: RealmService) {
        self.realmService = realmService
        
        categories = realmService.realm.objects(Category.self)
    }
}
