// hankyeol-dev. Data

import Foundation
import Domain
import Moya

public enum PostRouter {
   case uploadPost(input: PostInputType)
   case uploadFiles(input: UploadFileInputType)
   case getPost(postId: String)
   case getPosts(query: GetPostQueryType)
   case getPostsByUser(userId: String, query: GetPostQueryType)
   case getLikedPosts(query: GetPostQueryType)
   case getLiked2Posts(query: GetPostQueryType)
   case comments(postId: String, input: CommentInputType)
   case postLike(postId: String, Bool)
   case postLike2(postId: String, Bool)
}

extension PostRouter: RouterType {
   public var path: String {
      switch self {
      case .uploadPost: return "/posts"
      case .uploadFiles: return "/posts/files"
      case let .getPost(postId): return "/posts/\(postId)"
      case .getPosts: return "/posts"
      case let .getPostsByUser(userId, _): return "/posts/users/\(userId)"
      case .getLikedPosts: return "/posts/likes/me"
      case .getLiked2Posts: return "/posts/likes-2/me"
      case let .comments(postId, _): return "posts/\(postId)/comments"
      case let .postLike(postId, _): return "posts/\(postId)/like"
      case let .postLike2(postId, _): return "posts/\(postId)/like-2"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .getPosts, .getPost, .getPostsByUser, .getLikedPosts, .getLiked2Posts:
         return .get
      case .uploadPost, .uploadFiles, .comments, .postLike, .postLike2:
         return .post
      }
   }
   
   public var task: Moya.Task {
      switch self {
      case let .uploadPost(input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      case let .uploadFiles(input):
         let files = input.files.map({
            return MultipartFormData(provider: .data($0), name: "files", fileName: "file")
         })
         return .uploadMultipart(files)
      case let .getPosts(query),
         let .getLikedPosts(query),
         let .getLiked2Posts(query),
         let .getPostsByUser(_, query):
         let queries: [String: String] = [
            "next": query.next.isEmpty ? "" : query.next,
            "limit": String(query.limit),
            "category": query.category
         ]
         return .requestParameters(parameters: queries, encoding: URLEncoding.queryString)
      case let .comments(_, input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      case let .postLike(_, isLike), let .postLike2(_, isLike):
         let body = ["like_status": isLike]
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      default:
         return .requestPlain
      }
   }
   
   public var headers: [String : String]? {
      let productIdFiels = [
         headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
      ]
      switch self {
      case .uploadFiles:
         return generateHeaderFields(true, .multipart, productIdFiels)
      default:
         return generateHeaderFields(true, .base, productIdFiels)
      }
   }
}

public enum MockPostRouter {
   case uploadPost(input: PostInputType)
   case uploadFiles(input: UploadFileInputType)
   case getPost(postId: String)
   case getPostComments(postId: String)
   case getPosts(query: GetPostQueryType)
   case getPostsByUser(userId: String, query: GetPostQueryType)
   case getPostsByHashtag(query: SearchQueryType)
   case getPostsByLocation(query: SearchGEOQueryType)
}

extension MockPostRouter: RouterProtocol {
   public var path: String {
      switch self {
      case .uploadPost:
         return "/posts"
      case .uploadFiles:
         return "/posts/files"
      case .getPost(let postId), .getPostComments(let postId):
         return "/posts/\(postId)"
      case .getPosts:
         return "/posts"
      case .getPostsByUser(let userId, _):
         return "/posts/users/\(userId)"
      case .getPostsByHashtag:
         return "/posts/hashtags"
      case .getPostsByLocation:
         return "/posts/geolocation"
      }
   }
   
   public var method: NetworkMethod {
      switch self {
      case .getPosts, .getPost, .getPostsByUser, .getPostsByHashtag, .getPostsByLocation, .getPostComments:
         return .GET
      case .uploadPost, .uploadFiles: return .POST
      }
   }
   
   public var parameters: [URLQueryItem]? {
      switch self {
      case let .getPosts(query), let .getPostsByUser(_, query):
         return [
            URLQueryItem(name: "next", value: query.next),
            URLQueryItem(name: "limit", value: String(query.limit))
//            URLQueryItem(name: "category[]", value: query.category)
         ]
      case let .getPostsByHashtag(query):
         return [
            .init(name: "next", value: query.next),
            .init(name: "limit", value: String(query.limit)),
            .init(name: "category", value: query.category),
            .init(name: "hashTag", value: query.hashTag)
         ]
      case let .getPostsByLocation(query):
         return [
//            .init(name: "category", value: query.category),
            .init(name: "longitude", value: String(query.longitude)),
            .init(name: "latitude", value: String(query.latitude)),
            .init(name: "maxDistance", value: String(query.maxDistance)),
            .init(name: "order_by", value: query.orderBy.rawValue),
            .init(name: "sort_by", value: query.sortBy.rawValue)
         ]
      default:
         return nil
      }
   }
   
   public var headers: [String : String] {
      switch self {
      case .uploadPost,
            .getPost,
            .getPosts,
            .getPostsByUser,
            .getPostsByHashtag,
            .getPostsByLocation,
            .getPostComments:
         return setHeader(.request, needToken: true, needProductId: true)
      case .uploadFiles(let input):
         return setHeader(.upload, needToken: true, needProductId: true, boundary: input.boundary)
      }
   }
   
   public var body: Data? {
      switch self {
      case let .uploadPost(input):
         return input.toJSON
      case let .uploadFiles(input):
         return asMultipartFormDatas(boundary: input.boundary, files: input.files, content: nil)
      default:
         return nil
      }
   }
}
