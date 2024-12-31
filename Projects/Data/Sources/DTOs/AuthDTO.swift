
import Foundation

// MARK: InputType

public struct JoinInputType: Encodable {
   public let email: String
   public let password: String
   public let nick: String
}

public struct ValidationEmailInputType: Encodable {
   public let email: String
}

public struct LoginInputType: Encodable {
   public let email: String
   public let password: String
}


// MARK: OutputType

public struct JoinOutputType: Decodable {
   let userId: String
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
   }
}

public struct LoginOutputType: Decodable {
   let userId: String
   let email: String
   let nick: String
   let profileImage: String?
   let accessToken: String
   let refreshToken: String
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case email
      case nick
      case profileImage
      case accessToken
      case refreshToken
   }
}

public struct TokenOutputType: Decodable {
   let accessToken: String
   let refreshToken: String
}

public struct WithdrawOutputType: Decodable {
   let userId: String
   let email: String
   let nick: String
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case email
      case nick
   }
}
