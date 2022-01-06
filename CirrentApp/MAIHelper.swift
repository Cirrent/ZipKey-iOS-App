//
// Created by diverfd on 10/2/21.
// Copyright (c) 2021 Cirrent. All rights reserved.
//

import Foundation
import CirrentSDK

class MAIHelper {
    private let onError: (MAIError) -> () = { error in
        let errorType: ErrorType = error.errorType
        print("MAI: Failed. \nType: \(errorType), Msg: \n\(error.message)")
        switch errorType {
        case .request_failed,
             .reserved_step_name_used,
             .initialization_required,
             .init_data_collecting_is_active,
             .start_onboarding_required,
             .onboarding_type_required,
             .lack_of_location_permission:
            break
        case .end_onboarding_required:
            MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "new_onboarding_started"))
            MobileAppIntelligence.startOnboarding()
            break
        }
    }

    static func getAdditionalAttributes() -> [String: String] {
        let additionalAttributes = [
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        ]
        return additionalAttributes
    }

    func initializeMobileAppIntelligence() {
        let userModel = UserModel.shared
        if (!userModel.encodedCredentials.value.isEmpty) {
            initWithCloudToken()
        } else {
            initWithLocallyGeneratedToken()
        }
    }

    private func initWithCloudToken() {
        MobileAppIntelligence.initialize(token: UserModel.shared.token.value, onTokenInvalid: { retrier in
            print("MAI: Invalid Token. Retrying with a new one.")
            self.tryAgainWithNewCloudToken(retrier: retrier)
        }, onError: self.onError)
    }

    private func tryAgainWithNewCloudToken(retrier: Retrier) {
        TokenProvider.shared.getAnalyticsToken(success: { newToken in
            retrier.retry(token: newToken)
        })
    }

    private func initWithLocallyGeneratedToken() {
        MobileAppIntelligence.initialize(token: generateToken(), onTokenInvalid: { retrier in
            retrier.retry(token: self.generateToken())
        }, onError: onError)
    }

    private func generateToken() -> String {
        let appId = UserModel.shared.appId.value
        print("The user wasn't logged in. Default creds were used for token generation. App ID: \(appId)")
        return MobileAppIntelligence.createToken(
                expiresIn: 900,
                accountId: "accountId",
                appId: appId,
                appKey: "appKey",
                appSecret: "appSecret"
        )
    }
}
