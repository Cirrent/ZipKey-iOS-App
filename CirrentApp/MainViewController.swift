//
//  MainViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 18.07.17.
//
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            let homeCordination = HomeCoordinator(navigationController: self.navigationController!)
            homeCordination.start()
        }
    }
}
