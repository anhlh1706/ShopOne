/// Bym

import UIKit
import Anchorage

final class TransactionDetailItemView: UIView {
    
    private let nameLabel = Label(fontSize: 18, textAlignment: .center)
    
    private let quantityTitleLabel = Label(text: R.String.quantity, fontSize: 13, color: .subText, textAlignment: .center)
    private let quantityLabel = Label(color: .subText, textAlignment: .center)
    
    private let amountTitleLabel = Label(text: R.String.amount, fontSize: 13, color: .subText, textAlignment: .center)
    private let amountLabel = Label(color: .subText, textAlignment: .center)
    
    private let percentTitleLabel = Label(text: R.String.percent, fontSize: 13, color: .subText, textAlignment: .center)
    private let percentLabel = Label(color: .subText, textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(nameLabel)
        addSubview(quantityLabel)
        addSubview(amountLabel)
        addSubview(percentLabel)
        addSubview(quantityTitleLabel)
        addSubview(amountTitleLabel)
        addSubview(percentTitleLabel)
        
        nameLabel.topAnchor == topAnchor + 10
        nameLabel.leadingAnchor == leadingAnchor + 15
        
        amountTitleLabel.topAnchor == nameLabel.bottomAnchor + 8
        amountTitleLabel.centerXAnchor == centerXAnchor
        amountTitleLabel.widthAnchor == widthAnchor / 3 - 20
        
        quantityTitleLabel.centerYAnchor == amountTitleLabel.centerYAnchor
        quantityTitleLabel.trailingAnchor == amountTitleLabel.leadingAnchor
        quantityTitleLabel.widthAnchor == amountTitleLabel.widthAnchor
        
        percentTitleLabel.centerYAnchor == amountTitleLabel.centerYAnchor
        percentTitleLabel.leadingAnchor == amountTitleLabel.trailingAnchor
        percentTitleLabel.widthAnchor == amountTitleLabel.widthAnchor
        
        quantityLabel.centerXAnchor == quantityTitleLabel.centerXAnchor
        
        amountLabel.centerYAnchor == quantityLabel.centerYAnchor
        amountLabel.centerXAnchor == amountTitleLabel.centerXAnchor
        
        percentLabel.centerYAnchor == quantityLabel.centerYAnchor
        percentLabel.centerXAnchor == percentTitleLabel.centerXAnchor
        percentLabel.bottomAnchor == bottomAnchor
        
        heightAnchor == 82
    }
    
    func configure(index: Int, product: Product, percent: Int) {
        
        if index >= 0 {
            nameLabel.text = String(index + 1) + ". " + product.name
        } else {
            nameLabel.alpha = 0
        }
        quantityLabel.text = String(product.quantity)
        amountLabel.text = product.billing.vndFormat()
        percentLabel.text = String(percent) + "%"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
