//
//  SendCredentialsViaSoftApCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/13/19.
//

import UIKit
import CirrentSDK

class SendCredentialsViaSoftApCoordinator: RootCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(deviceId: String?,selectedNetwork: WiFiNetwork?,isHiddenNetwork: Bool?,preSharedKey: String?) {
        let sendCredentialsViaSoftVC = SendCredentialsViaSoftApViewController.instantiateStoryboard(.SendCredentialsViaSoftAp)
        sendCredentialsViaSoftVC.coordinator = self
        sendCredentialsViaSoftVC.setProperties(deviceId: deviceId,
                                               selectedNetwork: selectedNetwork,
                                               isHiddenNetwork: isHiddenNetwork,
                                               preSharedKey: preSharedKey)
        navigationController.fadeTo(sendCredentialsViaSoftVC)
    }
    
    func start(deviceId: String?,selectedNetwork: WiFiNetwork?, credentialsId: String?) {
        let sendCredentialsViaSoftVC = SendCredentialsViaSoftApViewController.instantiateStoryboard(.SendCredentialsViaSoftAp)
        sendCredentialsViaSoftVC.coordinator = self
        sendCredentialsViaSoftVC.setProperties(deviceId: deviceId,
                                               selectedNetwork: selectedNetwork,
                                               credentialsId: credentialsId)
        navigationController.fadeTo(sendCredentialsViaSoftVC)
    }
    
    func popToLastVC() {
        navigationController.popViewController(animated: false)
    }
}
