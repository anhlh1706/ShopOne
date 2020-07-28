/// Bym

import UIKit.UIView
import Anchorage
import Lottie

final class LottieLoaderView: UIView {
    let lottieView: AnimationView
    
    init(fromFile file: String, size: CGSize = CGSize(width: 200, height: 180)) {
        lottieView = AnimationView(name: file)
        super.init(frame: .zero)
        
        addSubview(lottieView)
        
        lottieView.sizeAnchors == size
        lottieView.centerAnchors == centerAnchors
        lottieView.loopMode = .loop
        lottieView.play()
        lottieView.contentMode = .scaleAspectFill
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lottieView.play()
    }
    
}
