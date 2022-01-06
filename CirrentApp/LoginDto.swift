//
//  LoginDto.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 11/8/17.
//

import EVReflection

class LoginDto: EVObject {
  var status = 0
  var data = Data()
  
  class Data: EVObject {
    var token = ""
    var user = User()
    var returnUrl = ""
    
    class User: EVObject {
      var roles = ""
      var idUser = 0
      var firstName = ""
      var lastName = ""
      var email = ""
      var idAccount = 0
      var verifiedEmail = 0
      var zendAuthToken = ""
      
      override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        return [
          (keyInObject: "roles", keyInResource: "Roles"),
          (keyInObject: "firstName", keyInResource: "FirstName"),
          (keyInObject: "lastName", keyInResource: "LastName"),
          (keyInObject: "email", keyInResource: "Email"),
          (keyInObject: "verifiedEmail", keyInResource: "VerifiedEmail"),
          (keyInObject: "zendAuthToken", keyInResource: "zend_auth_token")
        ]
      }
    }
  }
}
