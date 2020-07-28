/// Bym

import UIKit
import Anchorage

final class StorageCell: UICollectionViewCell {
    
    var profileImageView = UIImageView()
    var nameLabel   = Label(fontSize: 20, color: .text)
    var priceLabel  = Label(fontSize: 16, color: .subText)
    var numberLabel = Label(fontSize: 16, color: .subText)
    
    func configure(product: Product) {
        profileImageView.image  = product.image
        nameLabel.text          = product.name
        priceLabel.text         = R.String.price     + ": " + product.priceStr
        numberLabel.text        = R.String.available + ": " + product.quantityStr
        numberLabel.textColor   = product.quantity <= 0 ? .newRed : .subText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        
        contentView.addSubview(profileImageView)
        profileImageView.leadingAnchor == contentView.leadingAnchor
        profileImageView.centerYAnchor == contentView.centerYAnchor
        profileImageView.sizeAnchors == CGSize(width: 70, height: 70)
        
        addSubview(nameLabel)
        nameLabel.leadingAnchor == profileImageView.trailingAnchor + 10
        nameLabel.trailingAnchor == trailingAnchor - 5
        nameLabel.heightAnchor == 30
        nameLabel.topAnchor == topAnchor + 2
        
        addSubview(priceLabel)
        priceLabel.topAnchor == nameLabel.bottomAnchor
        priceLabel.leadingAnchor == profileImageView.trailingAnchor + 15
        
        addSubview(numberLabel)
        numberLabel.topAnchor == priceLabel.bottomAnchor + 3
        numberLabel.leadingAnchor == profileImageView.trailingAnchor + 15
        
        let separator = UIView(backgroundColor: .separator)
        
        addSubview(separator)
        separator.bottomAnchor == bottomAnchor
        separator.leadingAnchor == leadingAnchor + 15
        separator.trailingAnchor == trailingAnchor
        separator.heightAnchor == 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
