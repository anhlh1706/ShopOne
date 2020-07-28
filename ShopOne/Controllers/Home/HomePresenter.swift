/// Bym

import Foundation
import RealmSwift

protocol HomeDelegate: AnyObject {
    func didAddItemToCart(success: Bool, reloadIndex: Int?)
    func didRemoveACardItem()
    func didPay()
    func didSelectAProduct()
    func didUnselectAProduct()
}

final class HomePresenter: NSObject {
    
    let realmService: RealmService
    
    var storageItems: Results<Storage>
    
    var cartItems = [Storage]()
    
    var onHandProduct: Storage? {
        didSet {
            if onHandProduct == nil {
                delegate?.didUnselectAProduct()
            } else {
                delegate?.didSelectAProduct()
            }
        }
    }
    
    weak var delegate: HomeDelegate?
    
    init(realmService: RealmService) {
        self.realmService = realmService
        storageItems = realmService.realm.objects(Storage.self)
        super.init()
    }
    
    func take(product: Storage) {
        let selectingProduct = Storage(id: product.id,
                                       name: product.name,
                                       price: product.price,
                                       quantity: 1,
                                       image: product.image)
        selectingProduct.ofCategory = product.ofCategory
        onHandProduct = selectingProduct
    }
    
    func addProductToCart() {
        
        guard let product = onHandProduct else {
            delegate?.didAddItemToCart(success: false, reloadIndex: nil)
            return
        }
        
        /// if the cart already has this kind of product, increase quantity. Otherwise, add this product to cart
        if let order = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[order].quantity += product.quantity
            delegate?.didAddItemToCart(success: true, reloadIndex: order)
        } else {
            cartItems.append(product)
            delegate?.didAddItemToCart(success: true, reloadIndex: nil)
        }
        
        onHandProduct = nil
        
    }
    
    func saveDB() {
        for cartItem in cartItems {
            if let thisItemInSorage = storageItems.first(where: { $0.id == cartItem.id }) {
                let newQuantity = thisItemInSorage.quantity - cartItem.quantity
                realmService.update(thisItemInSorage, with: ["quantity": newQuantity])
                
                realmService.add(Transaction(storage: cartItem))
            }
        }
        cartItems.removeAll()
    }
    
    func totalAmountStr() -> String {
        return cartItems.reduce(0) { $0 + $1.billing }.addedSeparator()
    }
    
    func pay() {
        guard !cartItems.isEmpty else {
            AlertService.show(in: UIApplication.shared.visibleViewController, msg: R.String.emptyCartMsg)
            return
        }
        
        /// If storage has not enough quantity for all of item in cart, stop and show alert warning.
        for cartItem in cartItems {
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
        
        onHandProduct = nil
        saveDB()
        delegate?.didPay()
    }
    
    func removeCartItem(at index: Int) {
        cartItems.remove(at: index)
        delegate?.didRemoveACardItem()
    }
}

extension HomePresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: CartCell.self, indexPath: indexPath)
        cell.configure(product: cartItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let alert = UIAlertController(title: nil, message: R.String.removeCartMsg, preferredStyle: .alert)
        
        alert.addCancelAction()
        alert.addOkAction {
            self.removeCartItem(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        
        UIApplication.shared.visibleViewController.present(alert, animated: true, completion: nil)
    }
}
