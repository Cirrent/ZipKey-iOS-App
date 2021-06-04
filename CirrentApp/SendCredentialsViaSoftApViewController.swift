//
//  SendCredentialsViaSoftApViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 29.08.17.
//
//

import UIKit
import CirrentSDK


class SendCredentialsViaSoftApViewController: BaseLocalViewController {
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var connectingToLabel: UILabel!
    @IBOutlet weak var onboardingProcessLabel: UILabel!
    fileprivate var deviceId: String?
    fileprivate var isHiddenNetwork: Bool?
    fileprivate var preSharedKey: String?
    fileprivate var connectToNetworkCount = 0
    fileprivate var isConnectedToNetwork = false
    var coordinator: SendCredentialsViaSoftApCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        connectingToLabel.text = "Connecting to \(selectedNetwork?.getDecodedSsid() ?? "Connecting to XYZ Networks")…"
        
        putPrivateCredentialsViaSoftAp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoadingAnimation(imageView: loadingImageView)
        self.hideNavigationBar()
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
    
    fileprivate func putPrivateCredentialsViaSoftAp() {
        let softApSsid = UserModel.shared.softApSsid.value
        let priority = 200

        //----- SDK call ------------
        SoftApService.shared
            .setSoftApDeviceStatusTimings(softApDeviceStatusDelay: 5, softApDeviceStatusMaxRequestCount: 10)
            .putPrivateCredentialsViaSoftAp(
                isHiddenNetwork: isHiddenNetwork!,
                priority: priority,
                softApSsid: softApSsid,
                selectedNetwork: selectedNetwork!,
                preSharedKey: preSharedKey ?? "",
                delegate: self,
                exceptionHandler: { code, message in
                    MobileAppIntelligence.endOnboarding(
                            EndData.create(
                                    failureReason: "joining_failed"
                            ).setDebugInfo(
                                    ["error": message]
                            )
                    )
                    let alert = UIAlertController(title: "Warning", message: "Couldn't join network, try again.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self.coordinator?.popToRootView(viewController: self)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
            })
        //---------------------------
    }

    private func getNavigationController() -> UINavigationController {
        if let navigationController = self.navigationController {
            return navigationController
        } else {
            return coordinator!.navigationController
        }
    }
}

// SDK callback delegate implementation
extension SendCredentialsViaSoftApViewController: SoftApCredentialsSenderCallback {
    
    func onCredentialsSent() {
        print("SoftApCredentialsSenderCallback.onCredentialsSent() Called")
    }
    
    func onReturnedToNetworkWithInternet() {
        MobileAppIntelligence.enterStep(StepData.create(result: .success, stepName: "finishing", reason: "successfully_joined_network"))
        print("SoftApCredentialsSenderCallback.onReturnedToNetworkWithInternet() Called")
        SuccessCoordinator(navigationController: getNavigationController()).start(deviceId: deviceId, networkSsid: selectedNetwork?.getDecodedSsid())
    }
    
    func onFailedToReturnToNetworkWithInternet() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "failed_to_return_to_internet"))
        print("SoftApCredentialsSenderCallback.onFailedToReturnToNetworkWithInternet() Called")
        let alert = UIAlertController(title: "Warning", message: "Failed to re-connect to the private network", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func onNetworkJoiningFailed() {
        print("SoftApCredentialsSenderCallback.onNetworkJoiningFailed() Called")
        MobileAppIntelligence.enterStep(
                StepData.create(result: .failure, stepName: "enter_creds", reason: "couldnt_join_private_network")
        )
        let alert = UIAlertController(title: "Warning", message: "Failed to join network, let's try again.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToLastVC()
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    public func onIncorrectPriorityValueUsed() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "incorrect_priority_value"))
        print("SoftApCredentialsSenderCallback.onIncorrectPriorityValueUsed() Called")
        let alert = UIAlertController(title: "Warning", message: "Priority value should be between 150 and 255", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
