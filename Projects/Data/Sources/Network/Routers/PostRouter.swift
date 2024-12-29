// hankyeol-dev. Data

import Foundation
import Moya

public enum PostRouter {
   case uploadPost(input: PostInputType)
   case uploadFiles(input: UploadFileInputType)
   case getPost(postId: String)
   case getPosts(query: GetPostQueryType)
   case getLikedPosts(query: GetPostQueryType)
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
      case .getLikedPosts: return "/posts/likes/me"
      case let .comments(postId, _): return "posts/\(postId)/comments"
      case let .postLike(postId, _): return "posts/\(postId)/like"
      case let .postLike2(postId, _): return "posts/\(postId)/like-2"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .getPosts, .getPost, .getLikedPosts:
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
      case let .getPosts(query), let .getLikedPosts(query):
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
