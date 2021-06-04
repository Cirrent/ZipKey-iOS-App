//
//  HomeViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 24.07.17.
//
//

import UIKit
import CirrentSDK

class HomeViewController: UIViewController, Storyboarded {
    
    var coordinator: HomeCoordinator!
    
    // MARK: @IBOutlet
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = HomeCoordinator(navigationController: self.navigationController!)
        initStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        if #available(iOS 13.0, *) {
        setWindowColor(UIColor.getColorName(.window))
        } else {
            setWindowColor(.black)
        }
    }
    
    fileprivate func initStyle() {
        signInButton.layer.cornerRadius = 6
    }
    
    @IBAction func signInAction(_ sender: Any) {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "starting_login_process", reason: "moved_to_login_screen")
        )
        coordinator.signIn()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "waiting_for_onboarding", reason: "login_skipped")
        )
        UserModel.shared.setDefaultValues()
        coordinator.showProducts()
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://www.cirrent.com/terms-of-service/") {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func privacyButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://www.cirrent.com/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }
}
