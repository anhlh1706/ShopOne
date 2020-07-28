/// Bym

import UIKit
import Anchorage
final class LargeTitleHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor == leadingAnchor + 15
        titleLabel.verticalAnchors == verticalAnchors + 12
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 20, weight: .bold))
        
        tintColor = .clear
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
