/// Bym

import UIKit

extension UIColor {
    static let newRed           = UIColor(named: "red")!
    static let newBlue          = UIColor.systemBlue
    static let text             = UIColor(named: "text")!
    static let subText          = UIColor(named: "subText")!
    static let background       = UIColor(named: "background")!
    static let subBackground    = UIColor(named: "subBackground")!
    static let separator        = UIColor.quaternaryLabel
}

enum R {
    enum String {
        static let success  = NSLocalizedString("Successfully", comment: "")
        static let ok       = NSLocalizedString("Ok", comment: "")
        static let cancel   = NSLocalizedString("Cancel", comment: "")
        
        static let id       = NSLocalizedString("ID", comment: "")
        static let name     = NSLocalizedString("Name", comment: "")
        static let product  = NSLocalizedString("Product", comment: "")
        static let price    = NSLocalizedString("Price", comment: "")
        static let quantity = NSLocalizedString("Quantity", comment: "")
        static let amount   = NSLocalizedString("Amount", comment: "")
        static let percent  = NSLocalizedString("Percent", comment: "")
        static let category = NSLocalizedString("Category", comment: "")
        
        static let add      = NSLocalizedString("Add", comment: "")
        static let edit     = NSLocalizedString("Edit", comment: "")
        static let delete   = NSLocalizedString("Delete", comment: "")
        
        static let addToCart        = NSLocalizedString("Add to cart", comment: "")
        static let total            = NSLocalizedString("Total", comment: "")
        static let totalAmount      = NSLocalizedString("Total amount", comment: "")
        static let available        = NSLocalizedString("Available", comment: "")
        static let topSell          = NSLocalizedString("Top sell", comment: "")
        static let select           = NSLocalizedString("Select", comment: "")
        static let pay              = NSLocalizedString("Pay", comment: "")
        static let addCategory      = NSLocalizedString("Add category", comment: "")
        static func deleteCategory(_ category: Category) -> Swift.String {
            return Swift.String.localizedStringWithFormat(#"Delete "%@"?"#, category.title)
        }
        
        static let error                  = NSLocalizedString("Error", comment: "")
        static let invalidInput           = NSLocalizedString("Invalid input", comment: "")
        static let pickProductFirst       = NSLocalizedString("Pick product first", comment: "")
        static let emptyCartMsg           = NSLocalizedString("There is no product in the cart!", comment: "")
        static let overStorageMsg         = NSLocalizedString("Over storage, continue?", comment: "")
        static let `continue`             = NSLocalizedString("Continue", comment: "")
        static let removeCartMsg          = NSLocalizedString("Remove out of cart?", comment: "")
        static let closeWithoutSaving     = NSLocalizedString("Close without saving?", comment: "")
        static let noStorageItemMsg       = NSLocalizedString("There is no product, add some more first", comment: "")
        static let nothingHappened        = NSLocalizedString("Nothing happened", comment: "")
        static let categoryDeleteErrorMsg = NSLocalizedString("Make sure there is no product using this category first.", comment: "")
        
        static let options      = NSLocalizedString("Options", comment: "")
        static let moreDetail   = NSLocalizedString("More Detail", comment: "")
        
        static let fromLibrary  = NSLocalizedString("From library", comment: "")
        static let takeNewPhoto = NSLocalizedString("Take new photo", comment: "")
        
        static let homeTitle        = NSLocalizedString("Shop", comment: "")
        static let homeSelectTitle  = NSLocalizedString("Select a product", comment: "")
        static let storageTitle     = NSLocalizedString("Storage", comment: "")
        static let transactionTitle = NSLocalizedString("Transaction history", comment: "")
        static let categoryTitle    = NSLocalizedString("Category", comment: "")
        static let aboutTitle       = NSLocalizedString("About", comment: "")
    }
}

extension R {
    enum Key {
        static let storageIdCount       = "storageIdCount"
        static let transactionIdCount   = "transactionIdCount"
        static let categoryIdCount      = "categoryIdCount"
        static let firstLaunch          = "firstLaunch"
    }
}

extension R {
    enum Image {
        static let aboutTabBar          = UIImage(named: "aboutTabBar")!
        static let storageTabBar        = UIImage(named: "storageTabBar")!
        static let transactionTabbar    = UIImage(named: "transactionHistoryTabBar")!
        static let homeTabBar           = UIImage(named: "homeTabBar")!
        static let back                 = UIImage(named: "back")!
        static let confetti             = UIImage(named: "confetti")!
        static let githubIcon           = UIImage(named: "githubIcon")!
        static let noData               = UIImage(named: "noData")!
        static let placeholder          = UIImage(named: "placeholder")!
    }
}
