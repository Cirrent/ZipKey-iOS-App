//
//  UIViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 21.07.17.
//
//

import UIKit
import CirrentSDK

extension UIViewController {
    
    func infoAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        actionButton: String = "Ok") {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        
        alertController.addAction(UIAlertAction(title: actionButton, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func startLoadingAnimation(imageView: UIImageView) {
        UIView.animate(withDuration: 1) {
            imageView.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }, completion: nil)
    }
    
    func printClassName() {
        let className = String(describing:self)
        print("\(className)")
    }
}

// MARK: Keyboard
extension UIViewController {
    
    func keyboardSetup(_ scrollView: UIScrollView, isHideKeyboardWhenTappedAround: Bool = true) {
        keyboardNotificationRegister(scrollView)
        if isHideKeyboardWhenTappedAround {
            keyboardHideWhenTappedAround()
        }
    }
    
    func keyboardNotificationRegister(_ scrollView: UIScrollView) {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {sender in
            
            let info = sender.userInfo ?? [:]
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let adjustmentHeight = keyboardFrame.height + 20
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: adjustmentHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
        })
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: {sender in
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
        })
    }
    
    func keyboardHideWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.keyboardDismiss))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardDismiss() {
        view.endEditing(true)
    }

    func logOut() {
        MobileAppIntelligence.removeAllCollectedData()
        UserModel.shared.logout()
    }
    
    //MARK: - Navigation Bar
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - TabBar
    
    func isHiddenTabBar(_ hide: Bool) {
        self.hidesBottomBarWhenPushed = hide
        if let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController {
            tabBarVC.tabBar.isHidden = hide
        }
    }
    
    //MARK: - UIWindow
    
    func setWindowColor(_ color: UIColor) {
        if let window = (UIApplication.shared.delegate?.window)! as UIWindow! {
            window.backgroundColor = color
        }
    }
    
    func changeNavBarTitleColor(navBar: UINavigationBar) {
        let textAttributes: [NSAttributedString.Key : Any]
        if #available(iOS 13.0, *) {
            navBar.barTintColor = UIColor.getColorName(.panel)
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label]
        } else {
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        }
        navBar.titleTextAttributes = textAttributes
    }
    
    func changeNavBarShadowColor(navBar: UINavigationBar) {
        if #available(iOS 13, *) {
            if let shadowColor = UIColor(named: "navBarShadow") {
                navBar.shadowImage = UIImage.imageWithColor(color: shadowColor)
            }
        }
    }
    
    //MARK: - ios13
    
    /// Change View Background Color in iOS 13 from Color Mode
    func setBackgroundColor(color: UIColor) {
        if #available(iOS 13, *) {
            self.view.backgroundColor = color
        }
    }
    
    /// Change Navigation Bar Shadow Color in iOS 13 from Color Mode
    func changeNavBarShadowColor() {
        if #available(iOS 13, *) {
            navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.getColorName(.navBarShadow))
        }
    }
    
}
