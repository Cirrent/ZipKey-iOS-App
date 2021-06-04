//
//  ConnectViaBluetoothViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 12/19/17.
//

import UIKit
import CirrentSDK


class ConnectViaBluetoothViewController: BaseLocalViewController {
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var connectingToLabel: UILabel!
    var coordinator: ConnectViaBluetoothCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        startLoadingAnimation(imageView: loadingImageView)
        MobileAppIntelligence.setOnboardingType(type: .ble)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //----- SDK call ------------
        BluetoothService.shared
            .connectToDeviceViaBluetooth(blePrefix: UserModel.shared.blePrefix.value, delegate: self)
        //---------------------------
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar()
    }
    
    fileprivate func getInfo() {
        //----- SDK call ------------
        BluetoothService.shared.getDeviceInfoViaBluetooth(delegate: self)
        //---------------------------
    }
}

// SDK callback delegate implementation
extension ConnectViaBluetoothViewController: BluetoothDeviceConnectionCallback {
    func onBluetoothDisabled() {
        print("BluetoothDeviceConnectionCallback.onBluetoothDisabled() Called")
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "bluetooth_turned_off"))
        let alert = UIAlertController(title: "Warning", message: "Bluetooth is not enabled or not allowed for the app. Please enable Bluetooth in settings", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func onDeviceConnectedSuccessfully() {
        print("BluetoothDeviceConnectionCallback. Getting device info.")
        getInfo()
    }
    
    func onFailedToFindDevice() {
        print("BluetoothDeviceConnectionCallback.onFailedToFindDevice() Called")
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "failed_to_find_device"))
        let alert = UIAlertController(title: "Warning", message: "Failed to find device via bluetooth", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

// SDK callback delegate implementation
extension ConnectViaBluetoothViewController: BluetoothDeviceInfoCallback {

    func onOperationTimeLimitExceeded() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "time_limit_exceeded"))
        showAlert(title: "Communication error", msg: "Please reboot your device and try again.")
    }

    func onFailedToGetDeviceInfo() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "failed_to_get_device_info"))
        print("BluetoothDeviceInfoCallback.onFailedToGetDeviceInfo() Called")
        showAlert(title: "Warning", msg: "Failed to get device info")
    }
    
    func onConnectionIsNotEstablished() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "connection_is_not_established"))
        print("BluetoothDeviceInfoCallback.onConnectionIsNotEstablished() Called")
        showAlert(title: "Warning", msg: "Connection hasn't been established")
    }

    func onInfoReceived(deviceInfo: DeviceInfo, candidateNetworks: [WiFiNetwork]) {
        print("BluetoothDeviceInfoCallback.onInfoReceived() Called")
        let deviceId: String = deviceInfo.deviceId.isEmpty ? "<unknown>" : deviceInfo.deviceId
        MobileAppIntelligence.setOnboardingDeviceInfo(
                deviceId: deviceId,
                additionalAttributes: MAIHelper.getAdditionalAttributes()
        )
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "enter_creds", reason: "connected_via_ble")
        )
        ChooseNetworkViewCoordinator(navigationController: self.navigationController!)
                .start(deviceInfo: deviceInfo, candidateNetworks: candidateNetworks, isForBluetoothMethod: true)
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
