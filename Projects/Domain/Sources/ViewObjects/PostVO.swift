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
   /// superCategory -> content
   /// curationName -> title
   public let superCateogry: String
   public let curationName: String
   public let curationColorIndex: Int
   public let curationMakePublic: Int
   
   public init(
      superCateogry: String,
      curationName: String,
      curationColorIndex: Int,
      curationMakePublic: Int
   ) {
      self.superCateogry = superCateogry
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

public struct UploadFilesInputVO {
   public let files: [Data]
   
   public init(files: [Data]) {
      self.files = files
   }
}

public struct UploadPostInputVO {
   public let category: FoodCategories
   public let title: String
   public let content: String
   public let address: String // MARK: content1
   public let rate: Double // MARK: content2
   public let hashTag: String // MARK: content3
   public let files: [String]?
   public let longitude: Float?
   public let latitude: Float?
   
   public init(
      category: FoodCategories,
      title: String,
      content: String,
      address: String,
      rate: Double,
      hashTag: String,
      files: [String]?,
      longitude: Float?,
      latitude: Float?
   ) {
      self.category = category
      self.title = title
      self.content = content
      self.address = address
      self.rate = rate
      self.hashTag = hashTag
      self.files = files
      self.longitude = longitude
      self.latitude = latitude
   }
}

public struct GetPostQueryVO {
   public let next: String
   public let category: String
   
   public init(next: String, category: String) {
      self.next = next
      self.category = category
   }
}

public struct GetPostByHashtagVO {
   public let next: String
   public let category: String
   public let hashtag: String
   
   public init(next: String, category: String, hashtag: String) {
      self.next = next
      self.category = category
      self.hashtag = hashtag
   }
}

/// Output

public struct GetPostVO {
   public let postId: String
   public let category: String
   public let title: String
   public let likes: Int
   public let content: String
   public let address: String
   public let rate: Double
   public let hashTags: [String]
   public let files: [String]?
   public let creatorId: String
   public let creatorNick: String
   
   public init(postId: String, category: String, title: String, likes: Int, content: String, address: String, rate: Double, hashTags: [String], files: [String]?, creatorId: String, creatorNick: String) {
      self.postId = postId
      self.category = category
      self.title = title
      self.likes = likes
      self.content = content
      self.address = address
      self.rate = rate
      self.hashTags = hashTags
      self.files = files
      self.creatorId = creatorId
      self.creatorNick = creatorNick
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

public struct UploadFilesOutputVO {
   let files: [String]
   
   public init(files: [String]) {
      self.files = files
   }
}

public struct UploadPostOutputVO {
   public let postId: String
   
   public init(postId: String) {
      self.postId = postId
   }
}
