/// Bym

import UIKit
import Anchorage

final class NoDataView: UIView {
    
    init(text: String) {
        super.init(frame: .zero)
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "noData"))
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor == 0.573 * UIScreen.main.bounds.width
        
        let label = Label(text: text)
        label.heightAnchor == 60
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .text
        label.font = UIFont(name: "HevelticaNeue", size: 18)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.horizontalAnchors == horizontalAnchors
        stackView.centerYAnchor == centerYAnchor - 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
