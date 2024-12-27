// hankyeol-dev. Data

import Foundation
import Moya

public enum PostRouter {
   case uploadFiles(input: UploadFileInputType)
}

extension PostRouter: RouterType {
   public var path: String {
      switch self {
      case .uploadFiles: return "/posts/files"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .uploadFiles: return .post
      }
   }
   
   public var task: Moya.Task {
      switch self {
      case let .uploadFiles(input):
         let files = input.files.map({
            return MultipartFormData(provider: .data($0), name: "files", fileName: "file")
         })
         return .uploadMultipart(files)
      }
   }
   
   public var headers: [String : String]? {
      let productIdFiels = [
         headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
      ]
      switch self {
      case .uploadFiles:
         return generateHeaderFields(true, .multipart, productIdFiels)
      }
   }
}
