//
//  ChooseNetworkViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 31.07.17.
//
//

import UIKit
import CirrentSDK


class ChooseNetworkViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var containerPublicNetworkView: UIView!
    @IBOutlet weak var containerHiddenNetworkView: UIView!
    @IBOutlet weak var passwordViewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var ssidPublicLabel: UILabel!
    @IBOutlet weak var ssidHiddenTextField: UITextField!
    @IBOutlet weak var securityHiddenLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerSecurityPickerConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var securityPicker: UIPickerView!
    @IBOutlet weak var containerNetworkPickerConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var networkPicker: UIPickerView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var chooseNetworkNavBar: UINavigationBar!
    
    var coordinator: ChooseNetworkViewCoordinator?
    fileprivate var deviceId: String?
    fileprivate var deviceCandidateNetworks: [WiFiNetwork] = []
    fileprivate var selectedDeviceCandidateNetwork: WiFiNetwork?
    fileprivate let networkPickerTag = 3
    fileprivate let securityPickerTag = 7
    fileprivate var isHiddenNetwork = false
    fileprivate var knownNetworks: [DeviceKnownNetwork] = []
    fileprivate var securityTypes = ["OPEN", "WPA-PSK", "WPA2-PSK"]
    fileprivate var selectedSecurityTypes = "OPEN"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeNavBarTitleColor(navBar: chooseNetworkNavBar)
        keyboardHideWhenTappedAround()
        printClassName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavBarShadowColor(navBar: chooseNetworkNavBar)
        self.hideNavigationBar()
        if UserModel.shared.isSoftApOnboardingActivated.value {
            getDeviceInfoViaSoftAp()
        } else {
            networkPickerReload()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
    }
    
    func setProperties(deviceInfo: DeviceInfo, candidateNetworks: [WiFiNetwork]? = nil, knownNetworks: [DeviceKnownNetwork] = []) {
        self.deviceId = deviceInfo.deviceId
        if let candidateNetworks = candidateNetworks {
            self.deviceCandidateNetworks = candidateNetworks
        }
        self.knownNetworks = knownNetworks
    }
    
    fileprivate func getDeviceInfoViaSoftAp() {
        //----- SDK call ------------
        SoftApService.shared
            .setProgressView(customProgressView: CustomActivityIndicator.shared.with(message: "Getting device info via SoftAP"))
            .setSoftApPort(port: 80)
            .getDeviceInfoViaSoftAp(userAccountId: UserModel.shared.accountId.value, delegate: self, exceptionHandler: { code, message in
                MobileAppIntelligence.endOnboarding(
                        EndData.create(
                                failureReason: "cant_get_info_via_softap"
                        ).setDebugInfo(
                                ["error": message]
                        )
                )
                self.infoAlert(title: code, message: message)
            })
        //---------------------------
    }
    
    fileprivate func showOrHideNextButton() {
        if  isHiddenNetwork {
            if (ssidHiddenTextField.text?.isEmpty)! {
                nextButton.isHidden = true
            } else {
                nextButton.isHidden = false
            }
        } else {
            if selectedDeviceCandidateNetwork == nil {
                nextButton.isHidden = true
            } else {
                nextButton.isHidden = false
            }
        }
    }
    
    fileprivate func showContainerHiddenNetworks() {
        keyboardDismiss()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.containerSecurityPickerConstraintBottom.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func hideContainerHiddenNetworks() {
        UIView.animate(withDuration: 0.5, animations: {
            self.containerSecurityPickerConstraintBottom.constant = -262
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func hideContainerPublicNetworks() {
        UIView.animate(withDuration: 0.5, animations: {
            self.containerNetworkPickerConstraintBottom.constant = -262
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func hideAllPickers() {
        hideContainerHiddenNetworks()
        hideContainerPublicNetworks()
    }
    
    fileprivate func networkPickerReload() {
        // Preselect prepare
        let network = deviceCandidateNetworks.filter {
            return  $0.getDecodedSsid() == NetUtils.shared.getCurrentSsid() ||
                $0.getDecodedSsid() == UserModel.shared.privateSsid.value
        }
        if network.count > 0 {
            selectedDeviceCandidateNetwork = network[0]
            let selectedDecodedSsid = selectedDeviceCandidateNetwork?.getDecodedSsid()
            ssidPublicLabel.text = selectedDecodedSsid
            nextButton.isHidden = false
        }
        
        networkPicker.reloadAllComponents()
        
        // Preselect
        if network.count > 0 {
            networkPicker.selectRow(deviceCandidateNetworks.index(of: network[0])!, inComponent: 0, animated: true)
        }
    }
}

// MARK: - @IBAction
extension ChooseNetworkViewController {
    
    @IBAction func goBack(_ sender: Any) {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "back_pressed_on_setup_screen"))

        if UserModel.shared.isSoftApOnboardingActivated.value {
            SoftApService.shared.cancelAllTasks()
        } else {
            BluetoothService.shared.cancelAllTasks()
        }

        coordinator?.popToRootView(viewController: self)
    }
    
    @IBAction func goNext(_ sender: Any) {
        if (isHiddenNetwork && selectedSecurityTypes == "OPEN") || passwordTextField.text!.count >= 8 {
            checkIsHiddenNetwork()
            if UserModel.shared.isSoftApOnboardingActivated.value {
                SendCredentialsViaSoftApCoordinator(navigationController: self.navigationController!).start(
                        deviceId: deviceId,
                        selectedNetwork: selectedDeviceCandidateNetwork,
                        isHiddenNetwork: isHiddenNetwork,
                        preSharedKey: passwordTextField.text)
            } else {
                SendCredentialsViaBluetoothCoordinator(navigationController: self.navigationController!).start(
                        deviceId: deviceId,
                        selectedNetwork: selectedDeviceCandidateNetwork,
                        isHiddenNetwork: isHiddenNetwork,
                        preSharedKey: passwordTextField.text)
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "Password should have at least 8 characters", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }

    fileprivate func checkIsHiddenNetwork() {
        if isHiddenNetwork {
            let hiddenNetwork = WiFiNetwork();
            hiddenNetwork.ssid = ssidHiddenTextField.text!
            hiddenNetwork.flags = selectedSecurityTypes
            selectedDeviceCandidateNetwork = hiddenNetwork
            MobileAppIntelligence.enterStep(
                    StepData.create(
                            result: .success,
                            stepName: "joining_process_started",
                            reason: "joining_hidden_network"
                    ).setDebugInfo(
                            ["selected_ssid": hiddenNetwork.ssid]
                    )
            )
        } else {
            MobileAppIntelligence.enterStep(
                    StepData.create(
                            result: .success,
                            stepName: "joining_process_started",
                            reason: "joining_network"
                    ).setDebugInfo(
                            ["selected_ssid": selectedDeviceCandidateNetwork?.getDecodedSsid() ?? "nil"]
                    )
            )
        }
    }

    @IBAction func networkSwitchTaped(_ sender: Any) {
        isHiddenNetwork = networkSwitch.isOn
        
        if isHiddenNetwork {
            hideContainerPublicNetworks()
            passwordViewConstraintTop.constant = 192
            containerHiddenNetworkView.isHidden = false
            containerPublicNetworkView.isHidden = true
        } else {
            hideContainerHiddenNetworks()
            passwordViewConstraintTop.constant = 120
            containerHiddenNetworkView.isHidden = true
            containerPublicNetworkView.isHidden = false
        }
        showOrHideNextButton()
    }
    
    @IBAction func ssidHiddenEditingChanged(_ sender: Any) {
        showOrHideNextButton()
    }
    
    @IBAction func applySecutityPicker(_ sender: Any) {
        hideContainerHiddenNetworks()
        if !UserModel.shared.isSoftApOnboardingActivated.value {
            securityHiddenLabel.text = selectedSecurityTypes
        }
        showOrHideNextButton()
    }
    
    @IBAction func applyNetworkPicker(_ sender: Any) {
        hideContainerPublicNetworks()
        if selectedDeviceCandidateNetwork == nil {
            selectedDeviceCandidateNetwork = deviceCandidateNetworks[0]
        }
        let selectedDecodedSsid = selectedDeviceCandidateNetwork?.getDecodedSsid()
        ssidPublicLabel.text = selectedDecodedSsid
        showOrHideNextButton()
    }
    
    @IBAction func showContainerHiddenNetworksWhenButtonTaped(_ sender: Any) {
        showContainerHiddenNetworks()
    }
    
    @IBAction func showContainerHiddenNetworksWhenLabelTaped(_ sender: UITapGestureRecognizer) {
        showContainerHiddenNetworks()
    }
    
    @IBAction func showContainerPublicNetworksWhenButtonTaped(_ sender: Any) {
        showContainerPublicNetworks()
    }
    
    @IBAction func showContainerPublicNetworksWhenLabelTaped(_ sender: UITapGestureRecognizer) {
        showContainerPublicNetworks()
    }

    fileprivate func showContainerPublicNetworks() {
        keyboardDismiss()

        if deviceCandidateNetworks.count == 0 {
            return
        }

        UIView.animate(withDuration: 0.5, animations: {
            self.containerNetworkPickerConstraintBottom.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func eyeTaped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            eyeButton.setImage(#imageLiteral(resourceName: "eyeYellow"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(#imageLiteral(resourceName: "eyeDisable"), for: .normal)
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ChooseNetworkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case networkPickerTag:
            return deviceCandidateNetworks.count
        case securityPickerTag:
            return securityTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case networkPickerTag:
            return deviceCandidateNetworks[row].getDecodedSsid()
        case securityPickerTag:
            return securityTypes[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case networkPickerTag:
            selectedDeviceCandidateNetwork = deviceCandidateNetworks[row]
        case securityPickerTag:
            selectedSecurityTypes = securityTypes[row]
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate
extension ChooseNetworkViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideAllPickers()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardDismiss()
        return true
    }
}

// SDK callback delegate implementation
extension ChooseNetworkViewController: SoftApDeviceInfoCallback {
    public func onDeviceInfoReceived(deviceInfo: DeviceInfo, candidateNetworks: [WiFiNetwork]) {
        self.deviceId = deviceInfo.deviceId
        let unknownDeviceId = "<unknown>"
        let notEmptyDeviceId = self.deviceId?.isEmpty != false ? unknownDeviceId : self.deviceId
        MobileAppIntelligence.setOnboardingDeviceInfo(
                deviceId: notEmptyDeviceId ?? unknownDeviceId,
                additionalAttributes: MAIHelper.getAdditionalAttributes()
        )
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "enter_creds", reason: "connected_via_softap")
        )
        
        Utils.shared.addOnboardingHistoryItem(deviceInfo, LocalOnboardingType.softap)
        
        print("SoftApDeviceInfoCallback.onDeviceInfoReceived() Called")
        self.deviceCandidateNetworks = Utils.shared.getRidOfSoftApAndEmptySsids(candidateNetworks: candidateNetworks)
        self.networkPickerReload()
    }
}
