/// Bym

import UIKit

extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    func applyGradient(colors: [UIColor], direction: NSLayoutConstraint.Axis) {
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        var endPoint: CGPoint
        switch direction {
        case .horizontal:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            endPoint = CGPoint(x: 0.0, y: 1.0)
        @unknown default:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners(cornerRadius: Double, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder is UIView {
            responder = responder!.next
        }
        return responder as? UIViewController
    }
    
    func setGradientBackground(from: UIColor, to: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [from.cgColor, to.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func selfCapture(frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    class func animate(withStyle style: UIViewAnimationStyle,
                              delay: TimeInterval = 0,
                              animations: @escaping () -> Swift.Void,
                              completion: ((Bool) -> Swift.Void)? = nil) {

        animate(withDuration: style.duration,
                delay: delay,
                usingSpringWithDamping: style.dampingRatio,
                initialSpringVelocity: style.velocity,
                options: style.options,
                animations: animations,
                completion: completion)
    }
    
    func translateAndFade(as direction: TransitionalDirection,
                        animationStyle: UIViewAnimationStyle,
                        percentageEndPoint: TimeInterval = 1,
                        translate: CGPoint) {
        
        layer.removeAllAnimations()
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            transform.tx = translate.x
            transform.ty = translate.y
            alpha = 0
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                self.transform.tx = 0
                self.transform.ty = 0
                self.alpha = 1
            })
        }
        
        if direction == .transitionOut {
            transform.tx = 0
            transform.ty = 0
            alpha = 1
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                self.transform.tx = translate.x
                self.transform.ty = translate.y
                self.alpha = 0
            })
        }
    }
    
    enum TransitionalDirection {
        case transitionIn
        case transitionOut
    }
}

struct UIViewAnimationStyle {
    
    var duration: TimeInterval
    
    var delay: TimeInterval
    
    var dampingRatio: CGFloat
    
    var velocity: CGFloat
    
    var options: UIView.AnimationOptions
    
    init(duration: TimeInterval = 0.35,
         delay: TimeInterval = 0,
         dampingRatio: CGFloat = 1,
         velocity: CGFloat = 0,
         options: UIView.AnimationOptions = [.allowUserInteraction]) {
        self.duration = duration
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        self.options = options
    }
    
    static let transitionAnimationStyle = UIViewAnimationStyle(duration: 0.6, delay: 0, dampingRatio: 1, velocity: 0, options: .allowUserInteraction)
}
