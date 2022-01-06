//
//  RootCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/11/19.
//

import UIKit

class RootCoordinator {
    
    /// Pop To Root Controller animation false
    ///
    /// - Parameter viewController:UIViewController
    func popToRootView(viewController: UIViewController) {
        viewController.navigationController?.popToRootViewController(animated: false)
    }
}
