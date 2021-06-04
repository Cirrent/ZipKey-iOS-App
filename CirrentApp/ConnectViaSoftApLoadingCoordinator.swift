//
//  ConnectViaSoftApLoadingCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/12/19.
//

import UIKit
import CirrentSDK

class ConnectViaSoftApLoadingCoordinator: RootCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(softApSsid: String?) {
        let connectViaSoftApLoading = ConnectViaSoftApLoadingViewController.instantiateStoryboard(.ConnectViaSoftApLoading)
        connectViaSoftApLoading.setProperties(softApSsid: softApSsid)
        connectViaSoftApLoading.coordinator = self
        navigationController.pushViewController(connectViaSoftApLoading, animated: false)
    }
}
