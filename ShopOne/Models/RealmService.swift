/// Bym

import Foundation
import RealmSwift

final class RealmService {
    
    var storageAutoId: Int {
        realm.objects(Storage.self).last?.id ?? 0
    }
    
    var transactionAutoId: Int {
        realm.objects(Transaction.self).last?.transactionId ?? 0
    }
    
    var categoryAutoId: Int {
        realm.objects(Category.self).last?.id ?? 0
    }
    
    private init() {
        realm = try! Realm()
    }
    
    static let shared = RealmService()
    
    let realm: Realm
    
    func add<T: Object>(_ object: T) {
        
        switch object {
        case let object as Storage:
            addStorage(object)
        case let object as Transaction:
            addTransaction(object)
        case let object as Category:
            addCategory(object)
        default:
            break
        }
        
    }
    
    private func addStorage(_ storage: Storage) {
        
        storage.id = storageAutoId + 1
        
        do {
            try realm.write {
                realm.add(storage)
            }
        } catch {
            post(error)
        }
        
    }
    
    private func addTransaction(_ transaction: Transaction) {
        
        transaction.transactionId = transactionAutoId + 1
        
        do {
            try realm.write {
                realm.add(transaction)
            }
        } catch {
            post(error)
        }
        
    }
    
    private func addCategory(_ category: Category) {
        
        category.id = categoryAutoId + 1
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            post(error)
        }
        
    }
    
    func add(_ product: Storage, to category: Category?) {
        do {
            try realm.write {
                category?.products.append(product)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
                realm.add(object, update: .modified)
            }
        } catch {
            post(error)
        }
        
    }
    
    func detele<T: Object>(_ object: T) {
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
        
    }
    
    func remove(productAt index: Int, outOf category: Category) {
        do {
            try realm.write {
                category.products.remove(at: index)
            }
        } catch {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: .realmError, object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: .realmError, object: nil, queue: nil) { notification in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: .realmError, object: nil)
    }
}
