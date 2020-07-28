/// Bym

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.cellId)
    }
    
    func register<T: UITableViewHeaderFooterView>(view: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.headerId)
    }
    
    func dequeueReusableCell<T>(cell: T.Type = T.self, indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cell.cellId, for: indexPath) as? T else {
            fatalError("Error")
        }
        return cell
    }
    
}

extension UITableViewCell {
    
    static var cellId: String {
        return className
    }
    
    static var nib: UINib? {
        return UINib(nibName: cellId, bundle: nil)
    }
    
    var tableView: UITableView? {
        var table: UIView? = superview
        while !(table is UITableView) && table != nil {
            table = table?.superview
        }
        return table as? UITableView
    }
    
}

extension UITableViewHeaderFooterView {

    static var headerId: String {
        return className
    }
    
    static var nib: UINib? {
        return UINib(nibName: headerId, bundle: Bundle.main)
    }
}

extension NSObject {
    
    var className: String {
        return type(of: self).className
    }
    
    static var className: String {
        return String.className(self)
    }
}
