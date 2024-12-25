// hankyeol-dev. Data

import Foundation

@frozen
public enum UserDefaultsKeys: String {
   case userId
   case productId
   case accessToken
   case refreshToken
   case isLogined
}

@propertyWrapper
public struct UserDefaultsWrapper<T> {
   private let standard = UserDefaults.standard
   private let key: UserDefaultsKeys
   let defaultValue: T
   
   public init(key: UserDefaultsKeys, defaultValue: T) {
      self.key = key
      self.defaultValue = defaultValue
   }
   
   public var wrappedValue: T {
      get {
         standard.value(forKey: key.rawValue) as? T ?? defaultValue
      }
      
      set {
         standard.setValue(newValue, forKey: key.rawValue)
      }
   }
}
