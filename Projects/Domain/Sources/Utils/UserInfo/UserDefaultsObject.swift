// hankyeol-dev. Domain

import Foundation

protocol UserDefaultsObjectType {
   var userId: String { get }
   var userNickname: String { get }
   var productId: String { get }
   var accessToken: String { get }
   var refreshToken: String { get }
   var isLogined: Bool { get }
   
   mutating func setStringValue(_ key: UserDefaultsKeys, value: String)
   mutating func setBoolValue(_ key: UserDefaultsKeys, value: Bool)
}

struct UserDefaultsObject: UserDefaultsObjectType {
   @UserDefaultsWrapper(key: .userId, defaultValue: "")
   private(set) var userId: String
   
   @UserDefaultsWrapper(key: .userId, defaultValue: "")
   private(set) var userNickname: String

   @UserDefaultsWrapper(key: .productId, defaultValue: "")
   private(set) var productId: String
   
   @UserDefaultsWrapper(key: .accessToken, defaultValue: "")
   private(set) var accessToken: String
   
   @UserDefaultsWrapper(key: .refreshToken, defaultValue: "")
   private(set) var refreshToken: String
   
   @UserDefaultsWrapper(key: .isLogined, defaultValue: false)
   private(set) var isLogined: Bool
   
   mutating func setStringValue(_ key: UserDefaultsKeys, value: String) {
      switch key {
      case .userId:
         userId = value
      case .userNickname:
         userNickname = value
      case .productId:
         productId = value
      case .accessToken:
         accessToken = value
      case .refreshToken:
         refreshToken = value
      default:
         break;
      }
   }

   mutating func setBoolValue(_ key: UserDefaultsKeys, value: Bool) { isLogined = value }
}
