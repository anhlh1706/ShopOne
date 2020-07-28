/// Bym

import UIKit

struct AlertService {
    
    static func show(in vc: UIViewController, title: String? = nil, msg: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.String.ok, style: .default, handler: action)
        alert.addAction(okAction)
        
        if action != nil {
            alert.addCancelAction()
        }
        
        UIImpactFeedbackGenerator().impactOccurred()
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(in vc: UIViewController, msg: String) {
        show(in: vc, title: nil, msg: msg)
    }
    
    static func showSuccess(in vc: UIViewController) {
        show(in: vc, msg: R.String.success)
    }
}
