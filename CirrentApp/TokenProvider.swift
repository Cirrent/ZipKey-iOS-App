
import Foundation
import CirrentSDK

class TokenProvider {
    static let shared = TokenProvider()

    fileprivate init() {
    }

    func getAnalyticsToken(success: @escaping (_ analyticsToken: String) -> (),
                           unauthorized: (() -> ())? = nil,
                           failure: ((_ msg: String, _ code: RequesterError) -> ())? = nil,
                           progressDialog: CirrentProgressView? = nil) {
        print("The user is logged in. Getting token from the cloud. App ID: \(UserModel.shared.appId.value)")
        AnalyticsTokenRequester().doRequest(success: { (result) in
            if result.status == 401 {
                print("getAnalyticsToken() -> UNAUTHORIZED")
                if let unauthorized = unauthorized {
                    unauthorized()
                }
            } else {
                let token: String = result.token
                UserModel.shared.token.value = token
                print("getAnalyticsToken() -> SUCCESS")
                success(token)
            }
        }, failed: { message, code, statusCode in
            print("getAnalyticsToken() -> FAILED, message: \(message), code: \(code)")
            if let failure = failure {
                failure(message, code)
            }
        }, progressDialog: progressDialog)
    }
}
