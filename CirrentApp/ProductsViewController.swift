//
//  ProductsViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 24.07.17.
//
//

import UIKit
import CirrentSDK

import FirebaseCrashlytics
import CoreLocation

class ProductsViewController: UIViewController, Storyboarded {
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    fileprivate var isLocationPermissionsGranted: Bool = false
    fileprivate let maiHelper = MAIHelper()


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController {
            changeNavBarTitleColor(navBar: navBar.navigationBar)
        }

        navigationItem.removeBackButtonTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            setWindowColor(UIColor.getColorName(.window))
        } else {
            setWindowColor(.white)
        }
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.navigationController?.setYelowColorNavigationBar()
        self.changeNavBarShadowColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isHiddenTabBar(false)
        determineLocationAuthorizationStatus()
    }

    private func determineLocationAuthorizationStatus() {
        locationManager.delegate = self

        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break

        case .restricted, .denied:
            isLocationPermissionsGranted = false
            showLocationAlert(controller: self)
            break

        case .authorizedWhenInUse, .authorizedAlways:
            isLocationPermissionsGranted = true
            checkIfDeviceConnectedToSoftApNetwork()
            getTokenAndInitMAI()
            break
        }
    }

    fileprivate func showLocationAlert(controller: UIViewController) {
        let alertController = UIAlertController(
                title: "Permission Required", 
                message: "In order to perform the onboarding, you need to grant the app location permissions", 
                preferredStyle: .alert
        )
        let grantPermissions = UIAlertAction(title: "Grant Permissions", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { _ in

        })
        alertController.addAction(grantPermissions)
        alertController.addAction(cancel)
        controller.present(alertController, animated: true, completion: nil)
    }

    private func getTokenAndInitMAI() {
        maiHelper.initializeMobileAppIntelligence()
    }

    private func checkIfDeviceConnectedToSoftApNetwork() {
        let softApSsid = UserModel.shared.softApSsid.value
        let currentSsid = Utils.shared.getCurrentSsid()
        let softApAndCurrentSsidAreNotEmpty = !softApSsid.isEmpty && !currentSsid.isEmpty
        if (softApAndCurrentSsidAreNotEmpty && softApSsid == currentSsid) {
            CustomActivityIndicator.shared.with(message: "Disconnecting from the Soft AP network").showProgress()
            MobileAppIntelligence.enterStep(
                    StepData.create(
                            result: .success,
                            stepName: "disconnecting_from_softap",
                            reason: "still_connected_to_soft_ap"
                    )
            )
            SoftApService.shared.leaveSoftApNetwork(softApSsid: softApSsid) { isReturnedToPrivateNetwork in
                MobileAppIntelligence.enterStep(
                        StepData.create(
                                result: .success,
                                stepName: "waiting_for_onboarding",
                                reason: "successfully_disconnected_from_softap"
                        )
                )
                CustomActivityIndicator.shared.stopProgress()
            }
        }
    }
}

// MARK: @IBAction
extension ProductsViewController {
    @IBAction func findDevices(_ sender: Any) {
        if (!isLocationPermissionsGranted) {
            showLocationAlert(controller: self)
        } else {
            isHiddenTabBar(true)
            #if !arch(i386) && !arch(x86_64)
            if (UserModel.shared.isSoftApOnboardingActivated.value) {
                connectViaSoftAp()
            } else {
                connectViaBluetooth()
            }
            #endif
        }
    }

    fileprivate func connectViaSoftAp() {
        MobileAppIntelligence.startOnboarding(type: .softap)
        AnalyticsService.shared.logEvent(contentType: "real_flow", itemId: "soft_ap")
        UserModel.shared.privateSsid.value = NetUtils.shared.getCurrentSsid()
        MobileAppIntelligence.enterStep(
                StepData.create(
                        result: .success,
                        stepName: "connecting_via_softap",
                        reason: "softap_onboarding_started"
                )
        )
        ConnectViaSoftApLoadingCoordinator(navigationController: self.navigationController!).start(softApSsid: UserModel.shared.softApSsid.value)
    }

    fileprivate func connectViaBluetooth() {
        MobileAppIntelligence.startOnboarding(type: .ble)
        AnalyticsService.shared.logEvent(contentType: "real_flow", itemId: "ble")
        UserModel.shared.privateSsid.value = NetUtils.shared.getCurrentSsid()
        MobileAppIntelligence.enterStep(
                StepData.create(
                        result: .success,
                        stepName: "connecting_via_ble",
                        reason: "ble_onboarding_started"
                )
        )
        ConnectViaBluetoothCoordinator(navigationController: self.navigationController!).start()
    }
}

extension ProductsViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            isLocationPermissionsGranted = false
            showLocationAlert(controller: self)
            break

        case .authorizedWhenInUse, .authorizedAlways:
            isLocationPermissionsGranted = true
            checkIfDeviceConnectedToSoftApNetwork()
            getTokenAndInitMAI()
            break

        case .notDetermined:
            isLocationPermissionsGranted = false
            break
        }
    }
}


