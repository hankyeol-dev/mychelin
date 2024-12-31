// hankyeol-dev. Data

import Foundation

/// Input

public struct PostInputType: Encodable {
   public let category: String
   public let title: String
   public let price: Int?
   public let content: String
   public let content1: String?
   public let content2: String?
   public let content3: String?
   public let content4: String?
   public let content5: String?
   public let files: [String]?
   public let logitude: Float?
   public let latitude: Float?
}

public struct UploadFileInputType: Encodable {
   public let files: [Data]
}

public struct CommentInputType: Encodable {
   public let content: String
}

/// Query

public struct GetPostQueryType {
   public let next: String
   public let limit: Int = 5
   public let category: String
}

/// Output

public struct PostsFileOutputType: Decodable {
   public let files: [String]
}

public struct PostUploadOutputType: Decodable {
   public let postId: String
   
   enum CodingKeys: String, CodingKey {
      case postId = "post_id"
   }
}

public struct PostOutputType: Decodable {
   public let postId: String
   public let category: String
   public let tile: String
   public let price: Int?
   public let content: String
   public let content1: String?
   public let content2: String?
   public let content3: String?
   public let content4: String?
   public let content5: String?
   public let createdAt: String
   public let creator: MinProfileOutputType
   public let files: [String]
   public let likes: [String]
   public let likes2: [String]
   public let buyers: [String]
   public let hashTag: [String]
   public let comments: [CommentOutputType]
   public let geolocation: GEOLocation
   public let distance: Double?
   
   enum CodingKeys: String, CodingKey {
      case postId = "post_id"
      case category
      case tile
      case price
      case content
      case content1
      case content2
      case content3
      case content4
      case content5
      case createdAt
      case creator
      case files
      case likes
      case likes2
      case buyers
      case hashTag
      case comments
      case geolocation
      case distance
   }
}

public struct PostListOutputType: Decodable {
   public let data: [PostOutputType]
   public let next: String
   
   enum CodingKeys: String, CodingKey {
      case data
      case next = "next_cursor"
   }
}

public struct CommentOutputType: Decodable {
   public let commentId: String
   public let content: String
   public let createdAt: String
   public let creator: MinProfileOutputType
   
   enum CodingKeys: String, CodingKey {
      case commentId = "comment_id"
      case content
      case createdAt
      case creator
   }
}

public struct PostLikeOutputType: Decodable {
   public let like: Bool
   
   enum CodingKeys: String, CodingKey {
      case like = "like_status"
   }
}
