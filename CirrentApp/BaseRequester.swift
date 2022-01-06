//
//  BaseRequester.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 21.07.17.
//
//

import Foundation
import Alamofire
import EVReflection
import CirrentSDK

enum RequesterError {
  case notConnectedToInternet
  case other
}

class BaseRequester<J:NSObject>: NSObject where J: EVReflectable {
  var parameters: [String: Any]?
  var method: HTTPMethod?
  var headers: HTTPHeaders = [
    "Authorization": UserModel.shared.encodedCredentials.value,
    "Content-Type": "application/json"
  ]
  var encoding: ParameterEncoding!
  
  private var fullPath: String

    init(path: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, method: HTTPMethod? = nil) {
        let configuration: String? = Bundle.main.infoDictionary?["Configuration"] as? String
        var baseUrl = "https://go.cirrent.com/"
        if let checkedConfiguration = configuration {
            let stageSuffix = "(stage)"
            if (checkedConfiguration.hasSuffix(stageSuffix)) {
                baseUrl = "https://go.stg.cirrentsystems.com/"
            }
        }

        self.fullPath = baseUrl + path
        self.parameters = parameters
        self.method = method == nil ? HTTPMethod.get : method
        self.encoding = encoding

        EVReflection.setBundleIdentifier(J.self)

        super.init()
    }
  
  func doRequest(success: @escaping (_ result: J) -> (), failed: @escaping (_ message: String, _ code: RequesterError, _ statusCode: Int?) -> (), progressDialog: CirrentProgressView? = nil) {
    progressDialog?.showProgress()
    print(fullPath + " Called")
    
    let _ = Alamofire.request(fullPath, method: method!, parameters: parameters, encoding: encoding, headers: headers).responseString(completionHandler: { response in
      var status = 0
      if let value = response.response?.statusCode {
        status = value
      }
      
      print("RESPONSE for: \(self.fullPath): status: \(status), result: \(response.result.value ?? "")")
      
      switch response.result {
      case .success:
        
        switch (response.response?.statusCode)! {
        case 200:
          
          let j: J
          
          if self.isValidJson(obj: response.result.value ?? "") {
            j = J(json: response.result.value!)
          } else {
            j = J()
          }
          
          success(j)
          progressDialog?.stopProgress()
        default:
            failed("", .other, response.response?.statusCode)
            progressDialog?.stopProgress()
        }
        
      case .failure(let error):
        
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
          DispatchQueue.main.async {
            failed("You are not connected to the internet. Please go to Settings and turn on Wi-Fi.", .notConnectedToInternet, response.response?.statusCode)
            progressDialog?.stopProgress()
          }
        } else {
          DispatchQueue.main.async {
            failed("You are not connected to the internet.", .notConnectedToInternet, response.response?.statusCode)
            progressDialog?.stopProgress()
          }
        }
      }
      
    })
  }

  private func fromJson(obj: String) -> [String: Any] {
    var result: [String: Any] = [:]
    do {
      let jsonData: NSData = obj.data(using: String.Encoding.utf8)! as NSData
      let data = try (JSONSerialization.jsonObject(with: jsonData as Data, options: []))
      result = data as! [String: Any]
    } catch {

    }
    return result
  }

    private func isValidJson(obj: String) -> Bool {
        do {
            let jsonData = obj.data(using: String.Encoding.utf8)!
            try (JSONSerialization.jsonObject(with: jsonData, options: []))
            return true
        } catch {
            return false
        }
    }
}
