/// Bym

import UIKit
import QuartzCore

final class ConfettiView: UIView {
    
    let colors = [
        .newRed,
        UIColor.systemBlue,
        UIColor.systemOrange,
        UIColor.systemGreen,
        UIColor.systemPink,
        UIColor.systemPurple,
        UIColor.brown
    ]
    
    var emitter: CAEmitterLayer!
    var intensity: Float!
    var active = false
    
    let images = [
        UIImage(named: "confetti")!,
        UIImage(named: "confetti2")!
    ]
    
    init() {
        super.init(frame: .zero)
        intensity = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confetti(color: color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func confetti(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 5.0 * intensity
        confetti.lifetime = 15.0 * intensity
        confetti.lifetimeRange = 0
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = images.randomElement()?.cgImage
        confetti.color = color.cgColor
        
        return confetti
    }
}
