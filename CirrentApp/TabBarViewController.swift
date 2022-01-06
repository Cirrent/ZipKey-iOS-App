//
//  TabBarViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 24.07.17.
//
//

import UIKit
import CirrentSDK

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.viewControllers = [getRootProductVC(), getRootOnboardinghistoryTVC(), getRootSettingsVC()]
        (UIApplication.shared.delegate as! AppDelegate).connectViaSoftApLoadingIsActive = false
    }

    func configureTabBar() {
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.shadowOpacity = 0
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1)
        topBorder.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1).cgColor
        self.tabBar.layer.addSublayer(topBorder)
    }
    
    func getRootProductVC() -> UINavigationController {
        let productVC = ProductsViewController.instantiateStoryboard(.Products)
        let navigationRootProductVC = NavigationProductViewController(rootViewController: productVC)
        navigationRootProductVC.tabBarItem.tag = 0
        navigationRootProductVC.tabBarItem.title = "My Products"
        navigationRootProductVC.tabBarItem.image = UIImage(named: "home")
        return navigationRootProductVC
    }
    
    func getRootOnboardinghistoryTVC() -> UINavigationController {
        let historyVC = OnboardingHistoryTableViewController.instantiateStoryboard(.OnboardingHistory)
        let navigationRootHistoryVC = UINavigationController(rootViewController: historyVC)
        navigationRootHistoryVC.tabBarItem.tag = 2
        navigationRootHistoryVC.tabBarItem.title = "Onboarding History"
        navigationRootHistoryVC.tabBarItem.image = UIImage(named: "history")
        return navigationRootHistoryVC
    }
    
    func getRootSettingsVC() -> UINavigationController {
        let settingsVC = SettingsConfigurationViewController.instantiateStoryboard(.Settings)
        let navigationRootSettingsVC = UINavigationController(rootViewController: settingsVC)
        navigationRootSettingsVC.tabBarItem.tag = 1
        navigationRootSettingsVC.tabBarItem.title = "Settings"
        navigationRootSettingsVC.tabBarItem.image = UIImage(named: "settings")
        return navigationRootSettingsVC
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
