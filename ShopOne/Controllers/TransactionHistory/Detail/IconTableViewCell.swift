/// Bym

import UIKit
import Anchorage

final class IconTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let icon = UIImageView()
    private let labelStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        icon.sizeAnchors == CGSize(width: 36, height: 36)
        icon.contentMode = .scaleAspectFit
        
        contentView.addSubview(icon)
        
        [titleLabel, subtitleLabel].forEach { view in
            labelStack.addArrangedSubview(view)
        }
        
        labelStack.axis = .vertical
        labelStack.spacing = 8
        contentView.addSubview(labelStack)
        
        icon.leadingAnchor == contentView.leadingAnchor + 16
        icon.centerYAnchor == contentView.centerYAnchor
        
        labelStack.leadingAnchor == icon.trailingAnchor + 18
        labelStack.verticalAnchors == contentView.verticalAnchors + 8
        labelStack.trailingAnchor == contentView.trailingAnchor - 18
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        titleLabel.textColor = .text
        subtitleLabel.textColor = .subText
    }
    
    func config(transaction: Transaction) {
        titleLabel.text = transaction.name
        subtitleLabel.text = "\(transaction.quantity) . \(transaction.price.vndFormat()) . \(transaction.sellDateStr.suffix(maxLength: 8))"
        icon.image = transaction.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
