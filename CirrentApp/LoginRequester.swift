//
//  LoginRequester.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 11/8/17.
//

import Foundation
import EVReflection

class LoginRequester: BaseRequester<LoginDto> {
  
  init(username: String,
       password: String) {
    
    super.init(path: "api/login?username=\(String(describing: username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))&password=\(String(describing: password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""))", method: .post)
  }
}
