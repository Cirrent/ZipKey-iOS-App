//
//  SendCredentialsViaBluetoothViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 12/22/17.
//

import UIKit
import CirrentSDK


class SendCredentialsViaBluetoothViewController: BaseLocalViewController {
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var interruptedOnboardingProcess: UILabel!
    @IBOutlet weak var connectingToLabel: UILabel!
    fileprivate var isFailedToGetNetworkStatus = false;
    fileprivate var deviceId: String?
    fileprivate var isHiddenNetwork: Bool?
    fileprivate var preSharedKey: String?
    var coordinator: SendCredentialsViaBluetoothCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        connectingToLabel.text = "Sending credentials…"
        putPrivateCredentialsViaBluetooth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        startLoadingAnimation(imageView: loadingImageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setProperties(deviceId: String?,
                       selectedNetwork: WiFiNetwork?,
                       isHiddenNetwork: Bool? = nil,
                       preSharedKey: String? = nil,
                       credentialsId: String? = nil) {
        self.deviceId = deviceId ?? "<device_id>"
        self.selectedNetwork = selectedNetwork
        self.isHiddenNetwork = isHiddenNetwork
        self.preSharedKey = preSharedKey
        self.credentialsId = credentialsId
    }

    fileprivate func putPrivateCredentialsViaBluetooth() {
        //----- SDK call ------------
        let priority = 200
        BluetoothService.shared
            .putPrivateCredentialsViaBluetooth(
                isHiddenNetwork: isHiddenNetwork ?? false,
                priority: priority,
                preSharedKey: preSharedKey ?? "",
                selectedNetwork: selectedNetwork!,
                delegate: self)
        //---------------------------
    }
}

// SDK callback delegate implementation
extension SendCredentialsViaBluetoothViewController: BluetoothCredentialsSenderCallback {

    func onOperationTimeLimitExceeded() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "time_limit_exceeded"))
        showAlert(title: "Communication error", msg: "Please reboot your device and try again.")
    }

    func onCredentialsSent() {
        print("BluetoothCredentialsSenderCallback.onCredentialsSent() Called")
    }
    
    func onConnectionIsNotEstablished() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "connection_is_not_established"))
        print("BluetoothDeviceInfoCallback.onConnectionIsNotEstablished() Called")
        let alert = UIAlertController(title: "Warning", message: "Connection hasn't been established", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func onConnectedToPrivateNetwork() {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "finishing", reason: "successfully_joined_network")
        )
        print("BluetoothCredentialsSenderCallback.onConnectedToPrivateNetwork() Called")
        SuccessCoordinator(navigationController: getNavigationController()).start(deviceId: deviceId, networkSsid: selectedNetwork?.getDecodedSsid())
    }
    
    func onNetworkJoiningFailed() {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .failure, stepName: "enter_creds", reason: "couldnt_join_private_network")
        )

        print("BluetoothCredentialsSenderCallback.onNetworkJoiningFailed() Called")

        let alert = UIAlertController(title: "Warning", message: "Joining network failed. Please, try again.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToLastVC()
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func onFailedToGetNetworkStatus() {
        //Cirrent Agent specific behaviour
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "finishing", reason: "failed_to_get_network_status")
        )
        isFailedToGetNetworkStatus = true
        SuccessCoordinator(navigationController: getNavigationController()).start(deviceId: deviceId, networkSsid: selectedNetwork?.getDecodedSsid())
    }
    
    public func onIncorrectPriorityValueUsed() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "incorrect_priority_value"))
        let alert = UIAlertController(title: "Warning", message: "Priority value should be between 150 and 255", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    private func getNavigationController() -> UINavigationController {
        if let navigationController = self.navigationController {
            return navigationController
        } else {
            return coordinator!.navigationController
        }
    }

    private func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
