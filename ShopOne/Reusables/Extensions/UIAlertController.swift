/// Bym

import UIKit.UIAlertController

extension UIAlertController {
    func addCancelAction() {
        addAction(UIAlertAction(title: R.String.cancel, style: .cancel, handler: nil))
    }
    
    func addOkAction(handler: (() -> Void)?) {
        addAction(title: R.String.ok, handler: handler)
    }
    
    func addAction(title: String, handler: (() -> Void)?) {
        addAction(UIAlertAction(title: title, style: .default, handler: { _ in
            handler?()
        }))
    }
}
