
import Foundation
import CirrentSDK

class UserModel {

    static let shared = UserModel()

    fileprivate init() {
    }

    var appId = PreferenceWrapperFactory.create("appId", "")
    var encodedCredentials = PreferenceWrapperFactory.create("encodedCredentials", "")
    var softApSsid = PreferenceWrapperFactory.create("softApSsid", "")
    var blePrefix = PreferenceWrapperFactory.create("blePrefix", "")
    var privateSsid = PreferenceWrapperFactory.create("privateSsid", "")
    var accountId = PreferenceWrapperFactory.create("accountId", "")
    var token = PreferenceWrapperFactory.create("token", "<token>")
    var isSoftApOnboardingActivated = PreferenceWrapperFactory.create("isSoftApOnboardingActivated", false)
    var onboardingHistory = PreferenceWrapperFactory.create("user_onboarding_history", "")


    func setDefaultValues(appId: String? = nil) {
        if let appId = appId {
            self.appId.value = appId
        } else {
            self.appId.value = UUID().uuidString
        }

        if UserModel.shared.blePrefix.value.isEmpty {
            UserModel.shared.blePrefix.value = "CA_BLE"
        }
        if UserModel.shared.softApSsid.value.isEmpty {
            UserModel.shared.softApSsid.value = "ca-softap"
        }
    }

    func setEncodedCredentials(_ login: String, _ password: String) {
        encodedCredentials.value = "Basic " + (login + ":" + password).toBase64()
    }

    func logout() {
        isSoftApOnboardingActivated.clearObject()
        appId.clearObject()
        encodedCredentials.clearObject()
        softApSsid.clearObject()
        privateSsid.clearObject()
        accountId.clearObject()
        blePrefix.clearObject()
        onboardingHistory.clearObject()
    }
}
