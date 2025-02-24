// hankyeol-dev. Data

import Foundation
import Domain

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
   public let followers: [MinProfileOutputType]
   public let following: [MinProfileOutputType]
   public let posts: [String]
   
   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case email, nick, profileImage, phoneNum, info1, info2, info3, info4, info5, followers, following, posts
   }
   
   var toVO: MeProfileVO {
      return .init(userId: userId,
                   nick: nick,
                   profileImage: profileImage,
                   followers: followers.map({ $0.userId }),
                   following: following.map({ $0.userId}),
                   posts: posts)
   }
   
   public var toUpdatedProfileVO: ProfileUpdateVO { return .init(nick: nick, phoneNum: phoneNum) }
   public var toImageVO: ProfileImageVO { return .init(profileImage: profileImage) }
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

public struct UserListOutput: Decodable {
   public let data: [MinProfileOutputType]
   
   public var toUserListVO: UserListVO {
      return .init(list: data.map({ .init(userId: $0.userId, nick: $0.nick) }))
   }
}

public struct FollowOutputType: Decodable {
   public let me: String
   public let opponent: String
   public let status: Bool
   
   enum CodingKeys: String, CodingKey {
      case me = "nick"
      case opponent = "opponent_nick"
      case status = "following_status"
   }
}
