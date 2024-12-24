// hankyeol-dev. Domain

import Foundation

// MARK: InputVO
public struct JoinInputVO {
   public let email: String
   public let password: String
   public let nick: String
   
   public init(email: String, password: String, nick: String) {
      self.email = email
      self.password = password
      self.nick = nick
   }
}

public struct LoginInputVO {
   public let email: String
   public let password: String
   
   public init(email: String, password: String) {
      self.email = email
      self.password = password
   }
}

// MARK: OutputVO

