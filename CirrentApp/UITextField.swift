//
//  UITextField.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 20.07.17.
//
//

import UIKit

extension UITextField {

  func placeholderColor(_ color: UIColor) {
    self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
  }
}
