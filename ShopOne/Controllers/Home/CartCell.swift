/// Bym

import UIKit
import Anchorage

final class CartCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let quantityLabel = UILabel()
    let totalLabel = UILabel()
    
    func configure(product: Product) {
        nameLabel.text      = product.name
        priceLabel.text     = R.String.price    + ": " + product.priceStr + " vnd"
        quantityLabel.text  = R.String.quantity + ": " + product.quantityStr
        totalLabel.text     = R.String.total    + ": " + product.billingStr
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(quantityLabel)
        addSubview(totalLabel)
        
        nameLabel.topAnchor == topAnchor + 5
        nameLabel.leadingAnchor == leadingAnchor + 15
        nameLabel.trailingAnchor == totalLabel.leadingAnchor - 20
        
        priceLabel.topAnchor == nameLabel.bottomAnchor + 5
        priceLabel.leadingAnchor == leadingAnchor + 15
        priceLabel.bottomAnchor == bottomAnchor - 30
        
        quantityLabel.centerYAnchor == nameLabel.centerYAnchor
        quantityLabel.trailingAnchor == trailingAnchor - 15
        
        totalLabel.bottomAnchor == bottomAnchor - 5
        totalLabel.trailingAnchor == trailingAnchor - 15
        
        priceLabel.font = .systemFont(ofSize: 14)
        
        priceLabel.textColor = .subText
        nameLabel.textColor = .text
        quantityLabel.textColor = .text
        totalLabel.textColor = .text
        
        totalLabel.textAlignment = .right
        nameLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
