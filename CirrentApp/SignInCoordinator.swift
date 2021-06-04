//
//  SignInCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/3/19.
//

import UIKit

class SignInCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signInVC = SignInViewController.instantiateStoryboard(.Signing)
        signInVC.coordinator = self
        navigationController.pushViewController(signInVC, animated: true)
    }
    
    func presentForgotPassVC() {
        let forogotPassVC = ForgotPasswordViewController.instantiateStoryboard(.Signing)
        navigationController.customPush(vc: forogotPassVC)
    }
    
    func presentTabBar() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController.popToRootViewController(animated: false)
        appDelegate.appCoordinator.start()
        
    }
}
