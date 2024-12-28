// hankyeol-dev. Data

import Foundation
import Moya

public enum PostRouter {
   case uploadPost(input: PostInputType)
   case uploadFiles(input: UploadFileInputType)
   case getPost(postId: String)
   case getPosts(query: GetPostQueryType)
}

extension PostRouter: RouterType {
   public var path: String {
      switch self {
      case .uploadPost: return "/posts"
      case .uploadFiles: return "/posts/files"
      case let .getPost(postId): return "/posts/\(postId)"
      case .getPosts: return "/posts"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .getPosts, .getPost: return .get
      case .uploadPost, .uploadFiles: return .post
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
      case let .getPosts(query):
         let queries: [String: String] = [
            "next": query.next.isEmpty ? "" : query.next,
            "limit": String(query.limit),
            "category": query.category
         ]
         return .requestParameters(parameters: queries, encoding: URLEncoding.queryString)
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
