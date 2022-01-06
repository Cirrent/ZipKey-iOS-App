//
//  AnalyticsTokenRequester.swift
//  CirrentApp
//
//  Created by diverfd on 12/2/19.
//

import Foundation
import EVReflection

class AnalyticsTokenRequester: BaseRequester<TokenDto> {
    
    init() {
        super.init(path: "cloud/token/analytics")
    }
}
