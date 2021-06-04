//
//  SuccessViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 28.07.17.
//
//

import UIKit
import CirrentSDK


class SuccessViewController: UIViewController, Storyboarded {
    
    var coordinator: SuccessCoordinator?
    @IBOutlet weak var productSuccessImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var networkNameLabel: UILabel!
    @IBOutlet weak var successNavBar: UINavigationBar!
    
    fileprivate var deviceId: String?
    fileprivate var networkSsid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobileAppIntelligence.endOnboarding()
        changeNavBarTitleColor(navBar: successNavBar)
        initStyle()

        let unwrappedDeviceId = (deviceId == nil || deviceId!.isEmpty) ? "Product" : deviceId

        deviceNameLabel.text = "\(unwrappedDeviceId ?? "Product") is now connected"
        networkNameLabel.text = networkSsid ?? "<unknown>"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavBarShadowColor(navBar: successNavBar)
        self.hideNavigationBar()
    }
    
    func setProperties(deviceId: String?, networkSsid: String?) {
        self.deviceId = deviceId
        self.networkSsid = networkSsid
    }
    
    fileprivate func initStyle() {
        productSuccessImageView.clipsToBounds = true
        productSuccessImageView.contentMode = .scaleAspectFill
    }
}

// MARK: @IBAction
extension SuccessViewController {
    @IBAction func back(_ sender: Any) {
        coordinator?.popToRootView(viewController: self)
    }
    
    @IBAction func next(_ sender: Any) {
        coordinator?.popToRootView(viewController: self)
    }
}
