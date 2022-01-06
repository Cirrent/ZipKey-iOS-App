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
        self.deviceId = deviceId ?? ""
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
    public func onError(error: BluetoothCredsSenderError) {
        let errorMessage = error.rawValue
        print("BluetoothCredentialsSenderCallback. Error: \(errorMessage)")
        switch error {
        case .operationTimeLimitExceeded:
            endOnboarding(
                    endData: EndData.create(failureReason: "time_limit_exceeded"),
                    alertMessage: "Please reboot your device and try again."
            )
            break
        case .unknown,
             .unableToWriteData,
             .unableToDiscoverCharacteristics,
             .unableToDiscoverServices,
             .unableToReadResponse:
            //Cirrent Agent specific behaviour
            MobileAppIntelligence.enterStep(
                    StepData.create(result: .success, stepName: "finishing", reason: "failed_to_get_network_status")
            )
            SuccessCoordinator(navigationController: getNavigationController()).start(deviceId: deviceId, networkSsid: selectedNetwork?.getDecodedSsid())
            break
        case .incorrectPriorityValueUsed:
            endOnboarding(endData: EndData.create(
                    failureReason: "incorrect_priority_value"),
                    alertMessage: "Priority value should be between 150 and 255"
            )
            break
        case .invalidScdPublicKeyUsed:
            endOnboarding(
                    endData: EndData.create(failureReason: "invalid_scd_public_key_used"),
                    alertMessage: "Invalid scdPublicKey. Please reboot your device and try again."
            )
            break
        case .connectionIsNotEstablished:
            endOnboarding(
                    endData: EndData.create(failureReason: "connection_is_not_established"),
                    alertMessage: "Connection hasn't been established."
            )
            break
        }
    }

    func onCredentialsSent() {
        print("BluetoothCredentialsSenderCallback.onCredentialsSent() Called")
    }
    
    func onConnectedToPrivateNetwork() {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "finishing", reason: "successfully_joined_network")
        )
        print("BluetoothCredentialsSenderCallback.onConnectedToPrivateNetwork() Called")
        SuccessCoordinator(navigationController: getNavigationController()).start(deviceId: deviceId, networkSsid: selectedNetwork?.getDecodedSsid())
    }
    
    func onNetworkJoiningFailed(errorMessage: String) {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .failure, stepName: "enter_creds", reason: "couldnt_join_private_network")
        )

        print("BluetoothCredentialsSenderCallback.onNetworkJoiningFailed() Called")

        let alert = UIAlertController(title: "Warning", message: "Joining network failed. \(errorMessage)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToLastVC()
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
