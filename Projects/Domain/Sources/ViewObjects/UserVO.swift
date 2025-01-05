// hankyeol-dev. Domain

import Foundation

/// InputVO


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
