//
//  SettingsConfigurationViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 9/8/17.
//
//

import UIKit
import CirrentSDK

class SettingsConfigurationViewController: UIViewController, Storyboarded {
    
    var coordinator: SettingsCoordinator!
    
    @IBOutlet weak var softApSsidTextField: UITextField!
    @IBOutlet weak var blePrefixTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var onboardingType: UISegmentedControl!
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobileAppIntelligence.enterStep(StepData.create(result: .success, stepName: "configuring", reason: "moved_to_configuration"))
        coordinator = SettingsCoordinator(navigationController: self.navigationController!)
        
        if let navBar = navigationController {
            changeNavBarTitleColor(navBar: navBar.navigationBar)
        }
        
        softApSsidTextField.text = UserModel.shared.softApSsid.value
        blePrefixTextField.text = UserModel.shared.blePrefix.value
        initOnboardingType()
        setVersionAndBuildNumber()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.changeNavBarShadowColor()
    }
    
    override var description: String {
        "SettingsConfigurationViewController(version: \(version))"
    }

    private func initOnboardingType() {
        if (UserModel.shared.isSoftApOnboardingActivated.value) {
            onboardingType.selectedSegmentIndex = 1
        } else {
            onboardingType.selectedSegmentIndex = 0
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        isHiddenTabBar(false)
//    }

    private func setVersionAndBuildNumber() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        version.text = "\(appVersion) Build \(appBuildNumber)"
    }

    fileprivate func setConfirmButtonState() {
        let softApSsid = softApSsidTextField.text ?? ""
        let blePrefix = blePrefixTextField.text ?? ""
        if (softApSsid.isEmpty && blePrefix.isEmpty) {
            confirmButton.isHidden = true
        } else {
            confirmButton.isHidden = false
        }
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
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logOut()
        coordinator.presentHomeVC()
    }
}

// MARK: - @IBAction
extension SettingsConfigurationViewController {
    @IBAction func onboardingTypeChanged(_ sender: UISegmentedControl) {
        confirmButton.isHidden = false
    }
    
    @IBAction func softApSsidEditingChanged(_ sender: UITextField) {
        setConfirmButtonState()
    }
    
    @IBAction func blePrefixEditingChanged(_ sender: UITextField) {
        setConfirmButtonState()
    }
    
    @IBAction func confirmTaped(_ sender: UIButton) {
        if (onboardingType.selectedSegmentIndex == 1) {
            UserModel.shared.isSoftApOnboardingActivated.value = true
        } else {
            UserModel.shared.isSoftApOnboardingActivated.value = false
        }
        
        UserModel.shared.softApSsid.value = softApSsidTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        UserModel.shared.blePrefix.value = blePrefixTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        keyboardDismiss()

        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "waiting_for_onboarding", reason: "configuration_saved").setDebugInfo(
                        ["softap_ssid": UserModel.shared.softApSsid.value,
                        "ble_prefix": UserModel.shared.blePrefix.value,
                        "is_softap_onboarding_activated": "\(UserModel.shared.isSoftApOnboardingActivated.value)"]
                )
        )

        coordinator.showProductScreen()
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        keyboardDismiss()
        coordinator.showProductScreen()
    }
}

extension SettingsConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardDismiss()
        return true
    }
}
