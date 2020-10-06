/// Bym

import UIKit
import Anchorage
import SafariServices

final class AboutViewController: ViewController {
    
    private let confettiView = ConfettiView()
    private let stackView = UIStackView()
    private let runningCarView = LottieLoaderView(fromFile: "runningCar",
                                                  size: CGSize(width: UIScreen.main.bounds.width - 150,
                                                               height: (UIScreen.main.bounds.width - 150) * 0.8))
    private let introLabel = Label(text: intro, color: .text, textAlignment: .center)
    private let githubImageView = UIImageView(image: #imageLiteral(resourceName: "githubIcon").withRenderingMode(.alwaysTemplate))
    
    private var labelOrigin: CGPoint!
    private var facebookIconOrigin: CGPoint!
    private static let intro = """
        App: Untitled
        
        Cre: Bym
        
        Contact:
        Unknown
        
        ✉️
        Unknown@icloud.com
        
        Source open
        👇
        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.alpha = 1
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stackView.alpha = 0
    }
    
    override func setupView() {
        
        // Position
        stackView.axis = .vertical
        stackView.addArrangedSubview(runningCarView)
        stackView.addArrangedSubview(introLabel)
        stackView.addArrangedSubview(githubImageView)
        
        runningCarView.heightAnchor == (UIScreen.main.bounds.width - 150) * 0.55
        githubImageView.heightAnchor == (UIDevice.isIphone320Width ? 40 : 50)
        githubImageView.contentMode = .scaleAspectFit
        
        view.addSubview(stackView)
        stackView.spacing = 5
        stackView.horizontalAnchors == view.horizontalAnchors + 50
        stackView.centerYAnchor == view.centerYAnchor - 15
        
        view.addSubview(confettiView)
        confettiView.edgeAnchors == view.edgeAnchors
        
        // Properties
        githubImageView.tintColor = .text
        
        introLabel.numberOfLines = 0
        
        confettiView.startConfetti()
        confettiView.backgroundColor = .clear
        confettiView.isUserInteractionEnabled = false
    }
    
    override func setupInteraction() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)))
        stackView.addGestureRecognizer(pan)
        stackView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openGithub))
        githubImageView.isUserInteractionEnabled = true
        githubImageView.addGestureRecognizer(tap)
    }
    
    private var originalTouchPoint: CGPoint = .zero
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            var offset = touchPoint.y - originalTouchPoint.y
            offset = offset > 0 ? pow(offset, 0.8) : -pow(-offset, 0.8)
            stackView.transform = CGAffineTransform(translationX: 0, y: offset)
            
        case .ended, .cancelled:
            let timingParameters = UISpringTimingParameters(dampingRatio: 1)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.stackView.transform = .identity
            }
            animator.isInterruptible = true
            animator.startAnimation()
        default:
            break
        }
    }
    
    @objc func openGithub() {
        let githubURL = URL(string: "https://github.com/anhlh1706/shopOne")!
        let safariVC = SFSafariViewController(url: githubURL)
        present(safariVC, animated: true, completion: nil)
    }
}
