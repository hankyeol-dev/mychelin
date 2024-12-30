// hankyeol-dev. Data

import Foundation

/// Input

public struct ProfileEditInputType: Encodable {
   public let nick: String?
   public let phoneNum: String?
   public let info1: String?
   public let info2: String?
   public let info3: String?
   public let info4: String?
   public let info5: String?
}

public struct ProfileImageInputType: Encodable {
   public let profile: Data
}

/// Output

public struct ProfileOutputType: Decodable {
   public let userId: String
   public let email: String?
   public let nick: String
   public let profileImage: String?
   public let phoneNum: String?
   public let info1: String?
   public let info2: String?
   public let info3: String?
   public let info4: String?
   public let info5: String?
   public let followers: MinProfileOutputType
   public let following: MinProfileOutputType
   public let posts: [String]
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case email, nick, profileImage, phoneNum, info1, info2, info3, info4, info5, followers, following, posts
   }
}

public struct MinProfileOutputType: Decodable {
   public let userId: String
   public let nick: String
   public let profileImage: String?
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case nick, profileImage
   }
}
