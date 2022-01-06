//
// Created by diverfd on 11/3/20.
//

import Foundation

import CirrentSDK

class BaseLocalViewController: UIViewController, Storyboarded {
    var selectedNetwork: WiFiNetwork?
    var credentialsId: String?
    var onboardingType: LocalOnboardingType?

    func endOnboarding(endData: EndData, alertMessage: String) {
        MobileAppIntelligence.endOnboarding(endData)

        let alert = UIAlertController(title: "Warning", message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: false)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

enum LocalOnboardingType: String, Encodable, Decodable {
    case ble
    case softap
}
