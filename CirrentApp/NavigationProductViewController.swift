//
//  NavigationProductViewController.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/12/19.
//

import UIKit

class NavigationProductViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigation = self.navigationController {
            self.changeNavBarTitleColor(navBar: navigation.navigationBar)
        }
        self.changeNavBarShadowColor()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
