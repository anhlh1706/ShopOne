/// Bym

import UIKit.UIApplication
import RealmSwift
import RxSwift
import RxCocoa

protocol HomeDelegate: AnyObject {
    func didAddItemToCart(success: Bool, reloadIndex: Int?)
    func didPay()
}

final class HomePresenter {
    
    let realmService: RealmService
    
    var storageItems: Results<Storage>
    
    var cartItems: BehaviorRelay<[Storage]> = BehaviorRelay(value: [])
    
    var onHandProduct: BehaviorRelay<Storage?> = BehaviorRelay(value: nil)
    
    weak var delegate: HomeDelegate?
    
    init(realmService: RealmService) {
        self.realmService = realmService
        storageItems = realmService.realm.objects(Storage.self)
    }
    
    func take(product: Storage) {
        let selectingProduct = Storage(id: product.id,
                                       name: product.name,
                                       price: product.price,
                                       quantity: 1,
                                       image: product.image)
        selectingProduct.ofCategory = product.ofCategory
        onHandProduct.accept(selectingProduct)
    }
    
    func addProductToCart() {
        
        guard let product = onHandProduct.value else {
            delegate?.didAddItemToCart(success: false, reloadIndex: nil)
            return
        }
        
        /// if the cart already has this kind of product, increase quantity. Otherwise, add this product to cart
        if let order = cartItems.value.firstIndex(where: { $0.id == product.id }) {
            cartItems.value[order].quantity += product.quantity
            delegate?.didAddItemToCart(success: true, reloadIndex: order)
        } else {
            cartItems.accept(cartItems.value + [product])
            delegate?.didAddItemToCart(success: true, reloadIndex: nil)
        }
        
        onHandProduct.accept(nil)
        
    }
    
    func saveDB() {
        for cartItem in cartItems.value {
            if let thisItemInSorage = storageItems.first(where: { $0.id == cartItem.id }) {
                let newQuantity = thisItemInSorage.quantity - cartItem.quantity
                realmService.update(thisItemInSorage, with: ["quantity": newQuantity])
                
                realmService.add(Transaction(storage: cartItem))
            }
        }
        cartItems.accept([])
    }
    
    func totalAmountStr() -> String {
        return cartItems.value.reduce(0) { $0 + $1.billing }.addedSeparator()
    }
    
    func pay() {
        guard !cartItems.value.isEmpty else {
            AlertService.show(in: UIApplication.shared.visibleViewController, msg: R.String.emptyCartMsg)
            return
        }
        
        /// If storage has not enough quantity for all of item in cart, stop and show alert warning.
        for cartItem in cartItems.value {
            if let thisItemInStorage = storageItems.first(where: { $0.id == cartItem.id }) {
                
                if cartItem.quantity > thisItemInStorage.quantity {
                    AlertService.show(in: UIApplication.shared.visibleViewController, msg: R.String.overStorageMsg) { [weak self] _ in
                        self?.saveDB()
                        self?.delegate?.didPay()
                    }
                    return
                }
            }
        }
        
        onHandProduct.accept(nil)
        saveDB()
        delegate?.didPay()
    }
    
    func removeCartItem(at index: Int) {
        var current = cartItems.value
        current.remove(at: index)
        cartItems.accept(current)
    }
}
