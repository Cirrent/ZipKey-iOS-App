//
//  UINavigationController.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/2/19.
//

import UIKit

extension UINavigationController {
    
    func customPush(vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(vc, animated: false)
    }
    
    func customPop() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }
    
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func setYelowColorNavigationBar() {
        self.navigationBar.tintColor =  #colorLiteral(red: 0.9921568627, green: 0.7607843137, blue: 0, alpha: 1)
    }
    
    func pushViewControllerWithFlipAnimation(viewController:UIViewController){
        self.pushViewController(viewController
            , animated: false)
        if let transitionView = self.view{
            UIView.transition(with:transitionView, duration: 0.8, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    func popViewControllerWithFlipAnimation(){
        self.popViewController(animated: false)
        if let transitionView = self.view{
            UIView.transition(with:transitionView, duration: 0.8, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}
