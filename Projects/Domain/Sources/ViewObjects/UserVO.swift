// hankyeol-dev. Domain

import Foundation

/// InputVO
public struct ProfileUpdateVO {
   public let nick: String?
   public let phoneNum: String?
   
   public init(nick: String?, phoneNum: String?) {
      self.nick = nick
      self.phoneNum = phoneNum
   }
}

public struct ProfileImageUpdateVO {
   public let profile: Data
}

/// OutputVO

public struct MeProfileVO: Equatable {
   public let userId: String
   public let nick: String
   public let profileImage: String?
   public let followers: [String]
   public let following: [String]
   public let posts: [String]
   
   public init(
      userId: String,
      nick: String,
      profileImage: String?,
      followers: [String],
      following: [String],
      posts: [String]
   ) {
      self.userId = userId
      self.nick = nick
      self.profileImage = profileImage
      self.followers = followers
      self.following = following
      self.posts = posts
   }
}

public struct ProfileImageVO {
   public let profileImage: String?
   
   public init(profileImage: String?) {
      self.profileImage = profileImage
   }
}

public struct UserListVO {
   public let list: [SearchedUserVO]
   
   public init(list: [SearchedUserVO]) {
      self.list = list
   }
}

public struct SearchedUserVO {
   public let userId: String
   public let nick: String
   
   public init(userId: String, nick: String) {
      self.userId = userId
      self.nick = nick
   }
}
