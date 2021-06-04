//
// Created by diverfd on 11/3/20.
//

import Foundation

import CirrentSDK

class BaseLocalViewController: UIViewController, Storyboarded {
    var selectedNetwork: WiFiNetwork?
    var credentialsId: String?
    var onboardingType: LocalOnboardingType?
}

enum LocalOnboardingType {
    case ble
    case softap
}