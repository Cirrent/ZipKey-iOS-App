//
//  UIColor.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 9/3/19.
//

import UIKit

extension UIColor {
    
    enum ColorMode: String {
        case background, item, navBarShadow, panel, header, window
    }
    
    static func getColorName(_ name: ColorMode) -> UIColor {
        return UIColor.init(named: name.rawValue)!
    }
}

