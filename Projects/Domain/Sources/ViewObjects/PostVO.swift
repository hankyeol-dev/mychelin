// hankyeol-dev. Domain

import Foundation

/// Input
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

public struct CreateCurationInputVO {
   public let firstCategory: String
   public let curationName: String
   public let curationColorIndex: Int
   public let curationMakePublic: Int
   
   public init(
      firstCategory: String,
      curationName: String,
      curationColorIndex: Int,
      curationMakePublic: Int
   ) {
      self.firstCategory = firstCategory
      self.curationName = curationName
      self.curationColorIndex = curationColorIndex
      self.curationMakePublic = curationMakePublic
   }
}

public struct GetCurationPostsInputVO {
   public let category: String
   public let next: String
   public init(category: String, next: String) {
      self.category = category
      self.next = next
   }
}

/// Output

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

public struct GetCurationPostListVO {
   public let data: [GetPostVO]
   public let next: String
   public init(data: [GetPostVO], next: String) {
      self.data = data
      self.next = next
   }
}

public struct CreateCurationOutputVO {
   public let postId: String
   public init(postId: String) {
      self.postId = postId
   }
}

public struct GetCurationOutputVO {
   public let curationId: String
   public let curationName: String
   public let curationFirstCategory: String
   public let curationColorIndex: Int
   public let curationMakePublic: Int
   
   public init(
      curationId: String,
      curationName: String,
      curationFirstCategory: String,
      curationColorIndex: Int,
      curationMakePublic: Int
   ) {
      self.curationId = curationId
      self.curationName = curationName
      self.curationFirstCategory = curationFirstCategory
      self.curationColorIndex = curationColorIndex
      self.curationMakePublic = curationMakePublic
   }
}
