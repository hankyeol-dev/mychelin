// hankyeol-dev. Data

import Foundation
import Domain

public protocol RouterProtocol {
   var baseURL : String { get }
   var path: String { get }
   var method: NetworkMethod { get }
   var parameters: [URLQueryItem]? { get }
   var headers: [String: String] { get }
   var body: Data? { get }
}

public extension RouterProtocol {
   var baseURL: String {
      return env.baseURL
   }
   
   func asURL() throws(NetworkError) -> URL {
      guard var component = URLComponents(string: baseURL + path) else {
         throw .invalidURL
      }
      component.queryItems = parameters
      
      if let url = component.url {
         return url
      } else {
         throw .invalidURL
      }
   }
   
   func asURLRequest() throws(NetworkError) -> URLRequest {
      do {
         var request = URLRequest(url: try asURL())
         request.httpMethod = method.rawValue
         
         for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
         }
         
         if let body {
            request.httpBody = body
         }
         
         return request
      } catch {
         throw .invalidRequest
      }
   }
   
   func asMultipartFormDatas(
      boundary: String,
      fileKey : String = "files",
      files: [Data]?,
      content: [String: String]?
   ) -> Data {
      let crlf = "\r\n"
      var dataSet = Data()
      
      if let content {
         for (key, value) in content {
            dataSet.appendString("--\(boundary)\(crlf)")
            dataSet.appendString("Content-Disposition: form-data; name=\"\(key)\"\(crlf)\(crlf)")
            dataSet.appendString(value + crlf)
         }
      }
      
      if let files {
         files.forEach { file in
            dataSet.appendString("--\(boundary)\(crlf)")
            dataSet.appendString("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(Int(Date().timeIntervalSince1970)).jpeg\"\(crlf)")
            dataSet.appendString("Content-Type: image/jpeg\(crlf)\(crlf)")
            dataSet.append(file)
            dataSet.appendString("\(crlf)")
         }
      }
      
      dataSet.appendString("--\(boundary)--\(crlf)")
      
      return dataSet
   }
   
   func asMultipartContentDatas(input: Encodable?) -> [String : String]? {
      if let input,
         let contentData = try? JSONEncoder().encode(input),
         let contentDataDict = try? JSONSerialization.jsonObject(with: contentData) as? [String : Any] {
         return contentDataDict.mapValues { String(describing: $0) }
      }
      return nil
   }
}

public extension RouterProtocol {
   func setHeader(_ routerCase: RouterCase,
                  needToken: Bool,
                  needProductId: Bool,
                  boundary: String? = nil) -> [String: String] {
      var defaultHeader: [String: String] = [
         headerConfig.secretKey.rawValue: headerConfigValue.secret.rawValue,
         
         // MARK: content-type
         headerConfig.contentKey.rawValue
         : routerCase == .upload
         ? headerConfigValue.contentMultipart.rawValue + "; boundary=\(boundary ?? UUID().uuidString)"
         : routerCase == .image
         ? headerConfigValue.contentImage.rawValue
         : headerConfigValue.contentJson.rawValue,
      ]
      
      // MARK: token
      if needToken {
         defaultHeader[headerConfig.authKey.rawValue]
         = UserDefaultsProvider.shared.getStringValue(.accessToken)
      }
      
      if routerCase == .refresh {
         defaultHeader[headerConfig.refreshTokenKey.rawValue]
         = UserDefaultsProvider.shared.getStringValue(.refreshToken)
      }
      
      // MARK: productId
      if needProductId {
         defaultHeader[headerConfig.productIdKey.rawValue] = headerConfigValue.productId.rawValue
      }
      
      return defaultHeader
   }
}
