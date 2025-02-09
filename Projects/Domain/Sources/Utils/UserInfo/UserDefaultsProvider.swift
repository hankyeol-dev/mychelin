// hankyeol-dev. domain

import Foundation

public protocol UserDefaultsProviderType: AnyObject {
   func getStringValue(_ key: UserDefaultsKeys) -> String
   func setStringValue(_ key: UserDefaultsKeys, value: String)
   func getBoolValue() -> Bool
   func setBoolValue(_ key: UserDefaultsKeys, value: Bool)
}

public final class UserDefaultsProvider: UserDefaultsProviderType {
   public static let shared: UserDefaultsProvider = .init()
   private var userInfo: UserDefaultsObjectType = UserDefaultsObject()
   
   private init() {}
   
   public func getStringValue(_ key: UserDefaultsKeys) -> String {
      switch key {
      case .userId:
         return userInfo.userId
      case .userNickname:
         return userInfo.userNickname
      case .productId:
         return userInfo.productId
      case .accessToken:
         return userInfo.accessToken
      case .refreshToken:
         return userInfo.refreshToken
      default:
         return ""
      }
   }

   public func setStringValue(_ key: UserDefaultsKeys, value: String) {
      userInfo.setStringValue(key, value: value)
   }
   
   public func getBoolValue() -> Bool { return userInfo.isLogined }

   public func setBoolValue(_ key: UserDefaultsKeys, value: Bool) {
      userInfo.setBoolValue(key, value: value)
   }
}
