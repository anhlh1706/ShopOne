//
//  ViewController.swift
//  ShopOne
//
//  Created by Lê Hoàng Anh on 05/10/2020.
//

import UIKit
import Anchorage

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupView()
        setupInteraction()
        bindData()
    }
    
    func setupView() {}
    func setupInteraction() {}
    func bindData() {}
    
    func showErrorMessage(_ message: String, delay: TimeInterval = 3) {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let fatherView: UIView
        if let window = UIApplication.shared.windows.first {
            fatherView = window
        } else {
            fatherView = view
        }
        
        fatherView.subviews.forEach {
            if $0.tag == 99 {
                $0.removeFromSuperview()
            }
        }
        let containerView = UIView()
        containerView.tag = 99
        containerView.preservesSuperviewLayoutMargins = true
        containerView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.4352941176, blue: 0.5764705882, alpha: 1)
        fatherView.addSubview(containerView)
        containerView.topAnchor == fatherView.topAnchor
        containerView.horizontalAnchors == fatherView.horizontalAnchors
        
        let font = UIFont.systemFont(ofSize: 17, weight: .light)
        let label = Label(text: message, color: .background, textAlignment: .center)
        label.font = font
        label.numberOfLines = 0
        containerView.addSubview(label)
        label.horizontalAnchors == containerView.horizontalAnchors + 20
        label.bottomAnchor == containerView.bottomAnchor - 15
        
        containerView.heightAnchor == AppHelper.estimatedHeight(ofString: message, withFont: font, lineWidth: view.bounds.width - 40) + 25 + view.safeAreaInsets.top - navigationBarHeight
        
        /// Animating Container View
        containerView.layoutIfNeeded()
        containerView.transform.ty = -containerView.bounds.height
        UIView.animate(withDuration: 0.1, animations: {
            containerView.transform.ty = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.1, animations: {
                containerView.transform.ty = -containerView.bounds.height
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }
        
    }
    
    var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.bounds.height ?? 0
    }
}
