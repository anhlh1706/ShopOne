/// Bym

import UIKit

class Label: UILabel {
    
    @IBInspectable var localizeText: String = "" {
        didSet {
            text = localizeText.localized
        }
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }
    
    private func applyStyles() {
        applyUnderLine()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
    }
    
    private var underLineLayer = CALayer()
    
    private func applyUnderLine() {
        underLineLayer.removeFromSuperlayer()
        updateUnderLineFrame()
        updateUnderLineUI()
        layer.addSublayer(underLineLayer)
        layer.masksToBounds = true
    }
    
    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }
    
    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }
    
}
