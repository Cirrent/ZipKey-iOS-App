//
// Created by diverfd on 29/4/20.
//

import Foundation
import Alamofire

class NetworkListener {
    static let shared = NetworkListener()

    private let reachabilityManager: NetworkReachabilityManager?

    private init() {
        reachabilityManager = NetworkReachabilityManager()
    }

    func startListenToNetworkChange(_ completion: @escaping () -> ()) {
        reachabilityManager?.listener = { status in
            switch (status) {
            case .reachable(let type):
                if (type == .ethernetOrWiFi) {
                    completion()
                }
                break
            case .notReachable:
                break
            case .unknown:
                break
            }
        }

        reachabilityManager?.startListening()
    }

    func stop() {
        reachabilityManager?.stopListening()
    }
}