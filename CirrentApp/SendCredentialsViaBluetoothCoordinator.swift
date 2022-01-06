//
//  SendCredentialsViaBluetoothCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/13/19.
//

import UIKit
import CirrentSDK

class SendCredentialsViaBluetoothCoordinator: RootCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(deviceId: String?,selectedNetwork: WiFiNetwork?, isHiddenNetwork: Bool? = nil,preSharedKey: String? = nil) {
        let sendCredentialsViaBluetooth = SendCredentialsViaBluetoothViewController.instantiateStoryboard(.SendCredentialsViaBluetooth)
        sendCredentialsViaBluetooth.setProperties(deviceId: deviceId,
                                                  selectedNetwork: selectedNetwork,
                                                  isHiddenNetwork: isHiddenNetwork,
                                                  preSharedKey: preSharedKey)
        sendCredentialsViaBluetooth.coordinator = self
        navigationController.fadeTo(sendCredentialsViaBluetooth)
    }

    func start(deviceId: String?,selectedNetwork: WiFiNetwork?, credentialsId: String?) {
        let sendCredentialsViaBluetooth = SendCredentialsViaBluetoothViewController.instantiateStoryboard(.SendCredentialsViaBluetooth)
        sendCredentialsViaBluetooth.setProperties(deviceId: deviceId, selectedNetwork: selectedNetwork, credentialsId: credentialsId)
        sendCredentialsViaBluetooth.coordinator = self
        navigationController.fadeTo(sendCredentialsViaBluetooth)
    }

    func popToLastVC() {
        navigationController.popViewController(animated: false)
    }
}
