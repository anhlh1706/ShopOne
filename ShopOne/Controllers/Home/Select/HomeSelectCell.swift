/// Bym

import UIKit
import Anchorage

final class HomeSelectCell: UICollectionViewCell {
    
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var priceLabel = UILabel()

    func configure(withProduct product: Storage) {
        profileImageView.image = product.image
        nameLabel.text = product.name
        priceLabel.text = product.priceStr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.horizontalAnchors == horizontalAnchors
        profileImageView.heightAnchor == profileImageView.widthAnchor
        profileImageView.topAnchor == topAnchor
        
        addSubview(nameLabel)
        nameLabel.topAnchor == profileImageView.bottomAnchor + 5
        nameLabel.leadingAnchor == leadingAnchor + 3
        nameLabel.widthAnchor == profileImageView.widthAnchor
        nameLabel.heightAnchor == 25
        
        addSubview(priceLabel)
        priceLabel.sizeAnchors == CGSize(width: 100, height: 21)
        priceLabel.leadingAnchor == nameLabel.leadingAnchor
        priceLabel.topAnchor == nameLabel.bottomAnchor
        
        nameLabel.textColor = .text
        
        priceLabel.textColor = .subText
        priceLabel.font = .systemFont(ofSize: 14)
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
