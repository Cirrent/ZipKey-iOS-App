//
//  HomeCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/2/19.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController.instantiate()
        navigationController.fadeTo(homeVC)
    }

    func signIn() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.start()
    }

    func showProducts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController.popToRootViewController(animated: false)
        appDelegate.appCoordinator.showProductsScreen()
    }
}
