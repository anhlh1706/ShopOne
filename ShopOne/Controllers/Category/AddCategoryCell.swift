/// Bym

import UIKit

final class AddCategoryCell: UICollectionViewCell {
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        contentView.addSubview(button)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = UIColor.newBlue.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
