//
//  ChooseNetworkViewCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/11/19.
//

import UIKit
import CirrentSDK

class ChooseNetworkViewCoordinator:RootCoordinator {
    
    var navigationController: UINavigationController
    private let chooseNetworkVC = ChooseNetworkViewController.instantiateStoryboard(.ChooseNetwork)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(isForThirdMethod: Bool) {
        chooseNetworkVC.coordinator = self
        let deviceInfo = DeviceInfo()
        chooseNetworkVC.setProperties(deviceInfo: deviceInfo)
        navigationController.customPush(vc: chooseNetworkVC)
    }
    
    func start(deviceInfo: DeviceInfo, candidateNetworks: [WiFiNetwork]?, isForBluetoothMethod: Bool) {
        chooseNetworkVC.coordinator = self
        chooseNetworkVC.setProperties(deviceInfo: deviceInfo, candidateNetworks: candidateNetworks)
        navigationController.customPush(vc: chooseNetworkVC)
    }
    
    func dismissChoose() {
        self.navigationController.customPop()
    }
}
