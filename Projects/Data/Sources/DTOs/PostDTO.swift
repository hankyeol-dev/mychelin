// hankyeol-dev. Data

import Foundation
import Domain

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
   
   public init(
      category: String,
      title: String,
      price: Int? = nil,
      content: String,
      content1: String? = nil,
      content2: String? = nil,
      content3: String? = nil,
      content4: String? = nil,
      content5: String? = nil,
      files: [String]? = nil,
      logitude: Float? = nil,
      latitude: Float? = nil
   ) {
      self.category = category
      self.title = title
      self.price = price
      self.content = content
      self.content1 = content1
      self.content2 = content2
      self.content3 = content3
      self.content4 = content4
      self.content5 = content5
      self.files = files
      self.logitude = logitude
      self.latitude = latitude
   }
}

public struct UploadFileInputType: Encodable {
   public let boundary: String = UUID().uuidString
   public let files: [Data]
}

public struct CommentInputType: Encodable {
   public let content: String
}

/// Query

public struct GetPostQueryType {
   public let next: String
   public let limit: Int = 10
   public let category: String
}

/// Output

public struct PostsFileOutputType: Decodable {
   public let files: [String]
   
   public var toVO: UploadFilesOutputVO {
      return .init(files: files)
   }
}

public struct PostUploadOutputType: Decodable {
   public let postId: String
   
   enum CodingKeys: String, CodingKey {
      case postId = "post_id"
   }
   
   public var toVO: UploadPostOutputVO { return .init(postId: postId) }
}

public struct PostOutputType: Decodable {
   public let postId: String
   public let category: String
   public let title: String
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
   public let hashTags: [String]
   public let comments: [CommentOutputType]
   public let geolocation: GEOLocation
   public let distance: Double?
   
   enum CodingKeys: String, CodingKey {
      case postId = "post_id"
      case category
      case title
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
      case hashTags
      case comments
      case geolocation
      case distance
   }
   
   var toGetPostVO: GetPostVO {
      return .init(
         postId: postId,
         category: category,
         title: title,
         likes: likes.count,
         content: content,
         address: content1 ?? "",
         rate: Double(content2!) ?? 0.0,
         hashTags: hashTags,
         files: files,
         creatorId: creator.userId,
         creatorNick: creator.nick
      )
   }
   
   var toCreateCurationOutputVO: CreateCurationOutputVO {
      return .init(postId: postId)
   }
   
   var toGetCurationOutputVO: GetCurationOutputVO {
      return .init(
         curationId: postId,
         curationName: category,
         curationFirstCategory: title,
         curationColorIndex: content1 == nil ? 0 : Int(content1!) ?? 0,
         curationMakePublic: content2 == nil ? 0 : Int(content2!) ?? 0)
   }
}

public struct PostListOutputType: Decodable {
   public var data: [PostOutputType]
   public let next: String
   
   enum CodingKeys: String, CodingKey {
      case data
      case next = "next_cursor"
   }
   
   var toGetPostListVO: GetPostListVO {
      return .init(data: data.map({ $0.toGetPostVO }))
   }
   
   var toGetCurationPostListVO: GetCurationPostListVO {
      return .init(data: data.map({ $0.toGetPostVO }), next: next)
   }
}

public struct LocationSearchListOutput: Decodable {
   public var data: [PostOutputType]
   
   public var toVO: GetPostListVO {
      return .init(data: data.map({ $0.toGetPostVO }))
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
