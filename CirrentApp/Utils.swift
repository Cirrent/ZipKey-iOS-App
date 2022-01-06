import Foundation
import CirrentSDK
import SystemConfiguration.CaptiveNetwork

class Utils {

    static let shared = Utils()

    fileprivate init() {
    }

    func getFormattedTime(timeInMs: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInMs)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getFormattedOnboardingType(type: LocalOnboardingType) -> String {
        var formattedType: String
        switch type {
            case.ble: formattedType = "BLE"
                break
            default: formattedType = "Soft AP"
                break
        }
        return formattedType
    }
    
    func addOnboardingHistoryItem(_ deviceInfo: DeviceInfo, _ onboardingType: LocalOnboardingType) {
        OnboardingHistoryPrefManager.shared.addOnboardingHistoryItem(deviceInfo: deviceInfo, onboardingType: onboardingType)
    }
    
    func getRidOfSoftApAndEmptySsids(candidateNetworks: [WiFiNetwork]) -> [WiFiNetwork] {
        let filteredNetworks = candidateNetworks.filter {
            return $0.getPresentedSsid() != UserModel.shared.softApSsid.value && !$0.getPresentedSsid().isEmpty
        }

        return filteredNetworks
    }

    public func getCurrentSsid() -> String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        return "demo-home-network"
        #else
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            return ""
        }

        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            return ""
        }

        for interface in swiftInterfaces {
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                return ""
            }

            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                return ""
            }

            return SSIDDict["SSID"] as! String
        }

        return ""
        #endif
    }

    public func showAlert(controller: UIViewController,
                          shouldShowLoginScreen: Bool = false,
                          title: String,
                          message: String,
                          okAction ok: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let checkedOk = ok {
            alertController.addAction(checkedOk)
        } else {
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                if (shouldShowLoginScreen) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.appCoordinator.start()
                } else {
                    controller.navigationController!.popToRootViewController(animated: false)
                    controller.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }
            })
            alertController.addAction(ok)
        }

        controller.present(alertController, animated: true, completion: nil)
    }
}
