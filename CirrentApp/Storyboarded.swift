//
//  Storyboarded.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/2/19.
//

import UIKit

extension UIViewController {
    
    enum StoryboardName: String {
        case Main, Signing, TabBarViewController
        case Settings, OnboardingHistory, Products
        case ChooseNetwork, ConnectViaSoftApLoading
        case ConnectViaBluetooth, SendCredentialsViaBluetooth, SendCredentialsViaSoftAp
        case Success
    }
}

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {

    static func instantiate() -> Self {
        let className = String(describing: self)
        print("className == \(className)")
        let storyboard = UIStoryboard(name: className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
    static func instantiateStoryboard(_ name: StoryboardName) -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension Storyboarded where Self: UITabBarController {
    
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
}
