//
//  AppCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/2/19.
//

import UIKit
import CirrentSDK

class AppCoordinator {
    let window: UIWindow
    var rootViewController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
    }

    func start() {
        if (!UserModel.shared.accountId.value.isEmpty) {
            showProductsScreen()
        } else {
            rootViewController.pushViewController(MainViewController.instantiateStoryboard(.Main), animated: false)
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }

    func showProductsScreen() {
        window.rootViewController = TabBarViewController.instantiate()
        window.makeKeyAndVisible()
    }
}