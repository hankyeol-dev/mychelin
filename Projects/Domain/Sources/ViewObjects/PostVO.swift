// hankyeol-dev. Domain

import Foundation

public struct GEOSearchQueryVO {
   public let category: String
   public let longitude: Double
   public let latitude: Double
   public let maxDistance: Int
   
   public init(
      category: String,
      longitude: Double,
      latitude: Double,
      maxDistance: Int = 100
   ) {
      self.category = category
      self.longitude = longitude
      self.latitude = latitude
      self.maxDistance = maxDistance
   }
}

public struct GetPostVO {
   public let postId: String
   public let category: String
   public let title: String
   public let likes: Int
   
   public init(postId: String, category: String, title: String, likes: Int) {
      self.postId = postId
      self.category = category
      self.title = title
      self.likes = likes
   }
}

public struct GetPostListVO {
   public let data: [GetPostVO]
   
   public init(data: [GetPostVO]) {
      self.data = data
   }
}
