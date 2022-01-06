//
//  NavigationItem.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/5/19.
//

import UIKit

extension UINavigationItem  {

    ///  Clear back button text. You can see only icon
    func removeBackButtonTitle() {
        self.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
