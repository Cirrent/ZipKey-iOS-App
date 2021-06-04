//
//  ProductsCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/3/19.
//

import UIKit
import CirrentSDK

class ProductsCoordinator: Coordinator {

    var navigationController: UINavigationController
    var sendCredentialsViaSoftApCoordinator: SendCredentialsViaSoftApCoordinator!
    var chooseNetworkCoordinator: ChooseNetworkViewCoordinator!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let productVC = ProductsViewController.instantiateStoryboard(.Products)
        navigationController.pushViewController(productVC, animated: false)
    }
    
    func popToRootNavigationVC() {
        navigationController.popToRootViewController(animated: true)
    }
}
