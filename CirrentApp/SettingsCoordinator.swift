//
//  SettingsCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/3/19.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let settingsVC = SettingsConfigurationViewController.instantiateStoryboard(.Settings)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.pushViewController(settingsVC, animated: false)
    }
    
    func showProductScreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appCoordinator.showProductsScreen()
    }

    func presentHomeVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appCoordinator.start()
    }
}
