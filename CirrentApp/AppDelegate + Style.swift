//
//  AppDelegate + Style.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 20.07.17.
//
//

import UIKit

extension AppDelegate {

  func initStyle() {
    // style for navigation title
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Semibold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.black]
    
    // set color for bottom line
    UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
  }
}

