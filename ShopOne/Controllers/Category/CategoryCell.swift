/// Bym

import UIKit
import Anchorage

final class CategoryCell: UICollectionViewCell {
    
    let title = UILabel()
    let deleteButton = UIButton()

    func configure(with category: Category) {
        title.text = category.title
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [title, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        contentView.addSubview(stackView)
        
        stackView.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 17)
        
        deleteButton.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = contentView.frame.height / 2
        
        contentView.backgroundColor = UIColor.newBlue.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
