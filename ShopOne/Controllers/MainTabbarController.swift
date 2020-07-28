/// Bym

import UIKit

final class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .newRed
        
        let tabBarIconSize = CGSize(width: 24, height: 24)
        let realmService = RealmService.shared
        
        let homeVC          = HomeViewController(presenter: HomePresenter(realmService: realmService))
        let storageVC       = StorageViewController(presenter: StoragePresenter(realmService: realmService))
        let transactionVC   = TransactionHistoryViewController()
        let aboutVC         = AboutViewController()
        
        homeVC.tabBarItem    = UITabBarItem(title: R.String.homeTitle, image: R.Image.homeTabBar.scaleToFit(size: tabBarIconSize), tag: 0)
        storageVC.tabBarItem = UITabBarItem(title: R.String.storageTitle, image: R.Image.storageTabBar.scaleToFit(size: tabBarIconSize), tag: 1)
        transactionVC.tabBarItem = UITabBarItem(title: R.String.transactionTitle, image: R.Image.transactionTabbar.scaleToFit(size: tabBarIconSize), tag: 2)
        aboutVC.tabBarItem   = UITabBarItem(title: R.String.aboutTitle, image: R.Image.aboutTabBar.scaleToFit(size: tabBarIconSize), tag: 3)
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: storageVC),
            UINavigationController(rootViewController: transactionVC),
            aboutVC
        ]
        
        delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
    
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
        }, completion: { transitionContext.completeTransition($0) })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
}
