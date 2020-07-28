/// Bym

import UIKit.UIButton

final class PrimaryButton: UIButton {
    
    enum _Type {
        case text, rounder(CGFloat)
    }
    
    init(title: String = "", type: _Type) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        switch type {
        case .text:
            setTitleColor(.newRed, for: .normal)
        case .rounder(let radius):
            layer.cornerRadius = radius
            backgroundColor = .newRed
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
