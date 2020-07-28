/// Bym

import UIKit
import Anchorage

final class InfoView: UIView {
    
    init(title: String, value: String) {
        super.init(frame: .zero)

        let titleLabel = Label(text: title, fontSize: 18, color: .text)
        let valueLabel = Label(text: value, fontSize: 20, color: .subText)
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        
        addSubview(labelsStack)
        labelsStack.centerXAnchor == centerXAnchor
        labelsStack.centerYAnchor == centerYAnchor
        
        labelsStack.spacing = 5
        labelsStack.axis = .vertical
        
        heightAnchor == labelsStack.heightAnchor
        
        titleLabel.textAlignment = .center
        valueLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ProductDetailView: UIView {
    
    private let nameLabel = Label(fontSize: 30, color: .text)
    
    private let identifierInfo: InfoView
    
    private let priceInfo: InfoView
    
    private let quantityInfo: InfoView
    
    private let categoryInfo: InfoView
    
    private let blackView = UIView(backgroundColor: .black)
    
    private let vSeparator = UIImageView(backgroundColor: .separator)
    private let hSeparator = UIImageView(backgroundColor: .separator)
    
    init(product: Product) {
        
        nameLabel.text  = product.name
        identifierInfo  = InfoView(title: R.String.id, value: String(product.id))
        priceInfo       = InfoView(title: R.String.price, value: product.priceStr)
        quantityInfo    = InfoView(title: R.String.quantity, value: product.quantityStr)
        categoryInfo    = InfoView(title: R.String.category, value: product.categoryStr)
        
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 450))
        
        setGradientBackground(from: .newRed, to: .background)
        
        layer.cornerRadius = 25
        layer.masksToBounds = true
        
        addSubview(nameLabel)
        addSubview(vSeparator)
        addSubview(hSeparator)
        addSubview(identifierInfo)
        addSubview(priceInfo)
        addSubview(quantityInfo)
        addSubview(categoryInfo)
        
        nameLabel.topAnchor == topAnchor + 15
        nameLabel.centerXAnchor == centerXAnchor
        
        identifierInfo.topAnchor == nameLabel.bottomAnchor + 35
        identifierInfo.leadingAnchor == leadingAnchor
        identifierInfo.widthAnchor == widthAnchor / 2
        
        quantityInfo.topAnchor == identifierInfo.topAnchor
        quantityInfo.trailingAnchor == trailingAnchor
        quantityInfo.widthAnchor == widthAnchor / 2
        
        priceInfo.topAnchor == hSeparator.bottomAnchor + 10
        priceInfo.leadingAnchor == leadingAnchor
        priceInfo.widthAnchor == widthAnchor / 2

        categoryInfo.topAnchor == hSeparator.bottomAnchor + 10
        categoryInfo.trailingAnchor == trailingAnchor
        categoryInfo.widthAnchor == widthAnchor / 2

        hSeparator.topAnchor == quantityInfo.bottomAnchor + 10
        hSeparator.heightAnchor == 1
        hSeparator.horizontalAnchors == horizontalAnchors + 15

        vSeparator.topAnchor == nameLabel.bottomAnchor + 10
        vSeparator.widthAnchor == 1
        vSeparator.centerXAnchor == centerXAnchor
        vSeparator.bottomAnchor == priceInfo.bottomAnchor + 30
    }
    
    func show() {
        guard let window = UIWindow.key else { return }
        
        window.addSubview(self)
        window.addSubview(blackView)
        
        blackView.frame = window.bounds
        blackView.alpha = 0
        
        window.bringSubviewToFront(self)
        
        let hideDetailTap = UITapGestureRecognizer(target: self, action: #selector(hide))
        
        addGestureRecognizer(hideDetailTap)
        blackView.addGestureRecognizer(hideDetailTap)
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(translationX: 0, y: -400)
            self.blackView.alpha = 0.4
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = .identity
            self.blackView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.blackView.removeFromSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
