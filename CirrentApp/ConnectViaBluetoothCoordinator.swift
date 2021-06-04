//
//  ConnectViaBluetoothCoordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/13/19.
//

import UIKit

class ConnectViaBluetoothCoordinator: RootCoordinator, Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let connectViaBluetoothVC = ConnectViaBluetoothViewController.instantiateStoryboard(.ConnectViaBluetooth)
        connectViaBluetoothVC.coordinator = self
        navigationController.pushViewController(connectViaBluetoothVC, animated: false)
    }
}
