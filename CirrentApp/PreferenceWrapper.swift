//   Copyright 2016 NeatApps
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import Foundation

/**
 * This class is a wrapper class for API of the UserDefaults class.
 */

public class PreferenceWrapperFactory {
  fileprivate static let defaults = UserDefaults.standard
  
  /**
   The prefix for all user defaults names
   */
  public static var prefix = ""
  
  /**
   Call this when app goes background in AppDelegate
   */
  public static func synchronize() {
    defaults.synchronize()
  }
  
  /**
   Creates a wrapper with optional value
   */
  public static func create<T>(_ name: String) -> PreferenceWrapperOptional<T> {
    return PreferenceWrapperOptional(name)
  }
  
  /**
   Creates a wrapper with default value, so the value won't be optional
   */
  public static func create<T>(_ name: String, _ defaultValue: T) -> PreferenceWrapper<T> {
    return PreferenceWrapper(name, defaultValue)
  }
}

public class PreferenceWrapperOptional<T>: PreferenceWrapperBase<T> {
  public var value: T? {
    get {
      return PreferenceWrapperFactory.defaults.object(forKey: name) as? T
    }
    
    set(value) {
      PreferenceWrapperFactory.defaults.set(value, forKey: name)
    }
  }
}

public class PreferenceWrapper<T>: PreferenceWrapperBase<T> {
  private let defaultValue: T
  
  fileprivate init(_ name: String, _ defaultValue: T) {
    self.defaultValue = defaultValue
    super.init(name)
  }
  
  public var value: T {
    get {
      return PreferenceWrapperFactory.defaults.object(forKey: name) as? T ?? defaultValue
    }
    
    set(value) {
      PreferenceWrapperFactory.defaults.set(value, forKey: name)
    }
  }
}

 class PreferenceWrapperBase<T> {
  fileprivate let name: String
  
  public init(_ name: String) {
    self.name = PreferenceWrapperFactory.prefix + name
  }
  
  public func clearObject() {
    PreferenceWrapperFactory.defaults.removeObject(forKey: name)
  }
  
  public var objectExists: Bool {
    get {
      return PreferenceWrapperFactory.defaults.object(forKey: name) != nil
    }
  }
}
