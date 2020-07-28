/// Bym

import UIKit

class Button: UIButton {

    @IBInspectable var localizeTitle: String = "" {
        didSet {
            setTitle(localizeTitle.localized, for: .normal)
        }
    }
    
    @IBInspectable var leftRightInsets: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets = UIEdgeInsets(top: leftRightInsets, left: leftRightInsets, bottom: leftRightInsets, right: leftRightInsets * 5)
        }
    }
    
    @IBInspectable var centerVerticallyPadding: CGFloat = 0.0 {
        didSet {
            guard
                let imageViewSize = imageView?.frame.size,
                let titleLabelSize = titleLabel?.frame.size else {
                    return
            }
            
            let totalHeight = imageViewSize.height + titleLabelSize.height + CGFloat(centerVerticallyPadding)
            
            imageEdgeInsets = UIEdgeInsets(
                top: -(totalHeight - imageViewSize.height),
                left: 0.0,
                bottom: 0.0,
                right: -titleLabelSize.width
            )
            
            titleEdgeInsets = UIEdgeInsets(
                top: 0.0,
                left: -imageViewSize.width,
                bottom: -(totalHeight - titleLabelSize.height),
                right: 0.0
            )
            
            contentEdgeInsets = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: 0.0,
                right: 0.0
            )
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if leftRightInsets > 0.0 {
            return CGSize(width: size.width + leftRightInsets * 6, height: size.height + leftRightInsets * 2)
        }
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if leftRightInsets > 0.0 {
            return .init(width: size.width + leftRightInsets * 6, height: size.height + leftRightInsets * 2)
        }
        return .init(width: size.width, height: size.height)
    }
    
    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }
    
    @IBInspectable public var underLineColor: UIColor = UIColor.black.withAlphaComponent(0.15) {
        didSet {
            updateUnderLineUI()
        }
    }
    
    private var underLineLayer = CALayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
    }
    
    // MARK: Funcs
    private func applyStyles() {
        applyUnderLine()
    }
    
    private func applyUnderLine() {
        underLineLayer.removeFromSuperlayer()
        updateUnderLineFrame()
        updateUnderLineUI()
        layer.addSublayer(underLineLayer)
        layer.masksToBounds = true
    }
    
    private func updateUnderLineFrame() {
        guard let titleFrame = self.titleLabel?.frame else {return}
        var rect = titleFrame
        rect.origin.y = titleFrame.origin.y + titleFrame.height - 2
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }
    
    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }
}
