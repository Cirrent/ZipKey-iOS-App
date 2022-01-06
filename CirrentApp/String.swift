//
//  String.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 24.07.17.
//
//

import Foundation

extension String {

  func fromBase64() -> String? {
    guard let data = Data(base64Encoded: self) else {
      return nil
    }
    
    return String(data: data, encoding: .utf8)
  }
  
  func toBase64() -> String {
    return Data(self.utf8).base64EncodedString()
  }
}
