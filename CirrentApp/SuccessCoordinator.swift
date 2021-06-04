//
//  SuccessCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/13/19.
//

import UIKit
import CirrentSDK

class SuccessCoordinator:RootCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(deviceId: String?, networkSsid: String?) {
        let successVC = SuccessViewController.instantiateStoryboard(.Success)
        successVC.coordinator = self
        successVC.setProperties(deviceId: deviceId, networkSsid: networkSsid)
        navigationController.pushViewController(successVC, animated: false)
    }
    
    func presentAttributionLearnMore(url: String?) {
        let attributionLearnMore = AttributionLearnMoreViewCintroller.instantiateStoryboard(.Success)
        attributionLearnMore.coordinator = self
        attributionLearnMore.setProperties(url: url)
        navigationController.customPush(vc: attributionLearnMore)
    }
    
    func dismis() {
        navigationController.customPop()
    }
}
