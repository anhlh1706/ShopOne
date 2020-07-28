/// Bym

import UIKit
import Anchorage

final class TopOrderView: UIView {
    
    let nameField = AHTextField(primaryText: R.String.product)
    let priceField = AHTextField(primaryText: R.String.price)
    let quantityField = AHTextField(primaryText: R.String.quantity)
    let selectButton = PrimaryButton(title: R.String.select, type: .text)
    let addButton = PrimaryButton(title: R.String.addToCart, type: .text)
    
    var product: Product? {
        didSet {
            if let product = product {
                nameField.text = product.name
                quantityField.text = product.quantity == -1 ? "1" : product.quantityStr
                priceField.text = product.priceStr
            } else {
                nameField.text = ""
                quantityField.text = ""
                priceField.text = ""
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // Position
        let stack = UIStackView(arrangedSubviews: [nameField, priceField, quantityField])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)
        stack.topAnchor == topAnchor + 15
        stack.leadingAnchor == leadingAnchor + 20
        stack.widthAnchor == 150
        
        addSubview(selectButton)
        selectButton.topAnchor == stack.topAnchor + 5
        selectButton.leadingAnchor == stack.trailingAnchor + 5
        
        addSubview(addButton)
        addButton.bottomAnchor == stack.bottomAnchor + 15
        addButton.leadingAnchor == selectButton.leadingAnchor
        
        // Properties
        backgroundColor = .background
        
        nameField.isUserInteractionEnabled = false
        priceField.isUserInteractionEnabled = false
        
        quantityField.keyboardType = .numberPad
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
