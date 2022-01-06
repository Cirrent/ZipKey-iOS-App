//
//  AnalyticsService.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 11/14/17.
//

import Foundation
import Firebase

class AnalyticsService {
  static let shared = AnalyticsService()
  fileprivate init() {}
  
  func logEvent(contentType: String, itemId: String) {
    Analytics.logEvent(AnalyticsEventSelectContent,
                       parameters: [AnalyticsParameterContentType: contentType,
                                    AnalyticsParameterItemID: itemId])
  }
}
