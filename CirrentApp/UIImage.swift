//
//  UIImage.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 16.08.17.
//
//

import UIKit

extension UIImage {
  class func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}
