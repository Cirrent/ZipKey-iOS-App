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
    func onError(error: BluetoothDeviceConnectionError) {
        let errorMessage = error.rawValue
        print("BluetoothDeviceConnectionCallback. Error: \(errorMessage)")
        switch error {
        case .operationTimeLimitExceeded,
             .unknown,
             .unableToWriteData,
             .unableToDiscoverCharacteristics,
             .unableToDiscoverServices,
             .unableToReadResponse,
             .unableToConnect:
            let endData = EndData.create(failureReason: "communication_error").setDebugInfo(["error": errorMessage])
            endOnboarding(endData: endData, alertMessage: "Communication error: \(errorMessage)")
            break
        case .failedToFindDevice:
            let endData = EndData.create(failureReason: "failed_to_find_device")
            endOnboarding(endData: endData, alertMessage: "Failed to find device via bluetooth")
            break
        case .bluetoothIsNotReady:
            let endData = EndData.create(failureReason: "bluetooth_is_not_ready")
            let alertMessage = """
                               Bluetooth is not ready.
                               Please try to enable Bluetooth in Settings
                               """
            endOnboarding(endData: endData, alertMessage: alertMessage)
            break
        }
    }

    func onDeviceConnectedSuccessfully() {
        print("BluetoothDeviceConnectionCallback. Getting device info.")
        getInfo()
    }
}

// SDK callback delegate implementation
extension ConnectViaBluetoothViewController: BluetoothDeviceInfoCallback {
    func onError(error: BluetoothDeviceInfoError) {
        let errorMessage = error.rawValue
        print("BluetoothDeviceInfoCallback. Error: \(errorMessage)")
        switch error {
        case .operationTimeLimitExceeded,
             .unknown,
             .unableToWriteData,
             .unableToDiscoverCharacteristics,
             .unableToDiscoverServices,
             .unableToReadResponse:
            let endData = EndData.create(failureReason: "communication_error").setDebugInfo(["error": errorMessage])
            endOnboarding(endData: endData, alertMessage: "Communication error: \(errorMessage)")
            break
        case  .invalidScdPublicKeyReceived:
            let endData = EndData.create(failureReason: "invalid_scdPublicKey")
            endOnboarding(endData: endData, alertMessage: "Invalid scdPublicKey. Please reboot your device and try again.")
            break
        case .connectionIsNotEstablished:
            let endData = EndData.create(failureReason: "connection_is_not_established")
            endOnboarding(endData: endData, alertMessage: "Connection hasn't been established")
            break
        }
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
        
        Utils.shared.addOnboardingHistoryItem(deviceInfo, LocalOnboardingType.ble)
       
        ChooseNetworkViewCoordinator(navigationController: self.navigationController!)
                .start(
                        deviceInfo: deviceInfo,
                        candidateNetworks: Utils.shared.getRidOfSoftApAndEmptySsids(candidateNetworks: candidateNetworks),
                        isForBluetoothMethod: true
                )
    }
}
