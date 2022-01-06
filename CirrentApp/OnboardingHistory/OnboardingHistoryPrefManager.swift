
import UIKit
import CirrentSDK

class OnboardingHistoryPrefManager {
    public static let shared = OnboardingHistoryPrefManager()
    
    public func getOnboardingHistory() -> [OnboardingInfoModel] {
        let jsonHistory = UserModel.shared.onboardingHistory.value
        if (jsonHistory == "") {
            return []
        }
        let history = deserializeObjects(jsonString: jsonHistory)
        return history
    }
    
    public func addOnboardingHistoryItem(deviceInfo: DeviceInfo, onboardingType: LocalOnboardingType) {
        let unknownDeviceId = "<unknown>"
        let deviceId = deviceInfo.deviceId.isEmpty ? unknownDeviceId : deviceInfo.deviceId
        let accountId = deviceInfo.accountId.isEmpty ? unknownDeviceId : deviceInfo.accountId
        let timeMs = Double(Date().timeIntervalSince1970)
        let onBoardingHistoryItem = OnboardingInfoModel(deviceId: deviceId, accountId: accountId, time: timeMs, onboardingType: onboardingType)
        
        addOnboardingHistoryItem(onboardingInfoModel: onBoardingHistoryItem)
    }
    
    public func addOnboardingHistoryItem(onboardingInfoModel: OnboardingInfoModel) {
        var history: [OnboardingInfoModel] = getOnboardingHistory()
        history.append(onboardingInfoModel)
        let jsonHistory = serializeObjects(objects: history)
        UserModel.shared.onboardingHistory.value = jsonHistory
    }
    
    public func clearOnboardingHistory() {
        UserModel.shared.onboardingHistory.clearObject()
    }
    
    private func serializeObjects(objects: [OnboardingInfoModel])-> String {
        do {
            let payload: Data = try JSONEncoder().encode(objects)
            let res =  String(data: payload, encoding: .utf8) ?? ""
            return res
        }  catch {
            return ""
        }
    }
    
    private func deserializeObjects(jsonString: String)-> [OnboardingInfoModel] {
        do {
            let jsonData = Data(jsonString.utf8)
            return try JSONDecoder().decode([OnboardingInfoModel].self, from: jsonData)
        } catch {
            return []
        }
    }
    
}
