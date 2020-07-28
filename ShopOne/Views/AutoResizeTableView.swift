/// Bym

import UIKit

final class AutoResizeTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
