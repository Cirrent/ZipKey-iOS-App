
import UIKit

class OnboardingInfoModel: Encodable, Decodable {
    var deviceId: String
    var accountId: String
    var time: Double
    var onboardingType: LocalOnboardingType
    
    init(deviceId: String, accountId: String, time: Double, onboardingType: LocalOnboardingType) {
        self.deviceId = deviceId
        self.accountId = accountId
        self.time = time
        self.onboardingType = onboardingType
    }
    
}
