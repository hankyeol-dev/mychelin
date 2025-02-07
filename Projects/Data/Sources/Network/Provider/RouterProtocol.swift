// hankyeol-dev. Data

import Foundation
import Domain

public protocol RouterProtocol {
   var baseURL : String { get }
   var path: String { get }
   var method: NetworkMethod { get }
   var parameters: [URLQueryItem]? { get }
   var headers: Task<[String : String], Never> { get }
   var body: Data? { get }
}

public extension RouterProtocol {
   var baseURL: String {
      return env.baseURL
   }
   
   func asURL() throws(RouterError) -> URL {
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
   
   func asURLRequest() async throws(RouterError) -> URLRequest {
      do {
         var request = URLRequest(url: try asURL())
         request.httpMethod = method.rawValue
         
         for (key, value) in await headers.value {
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
   
   // MARK: multipart/form-data 형식으로 요청을 보내야하는 경우, body 형식을 맵핑
   func asMultipartFormDatas(
      boundary: String,
      fileKey : String = "image",
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
   
   // MARK: multipart/form-data 통신으로 들어올 때, content 형태로만 들어올 경우 활용
   func asMultipartContentDatas(input: Encodable?) -> [String : String]? {
      if let input,
         let contentData = try? JSONEncoder().encode(input),
         let contentDataDict = try? JSONSerialization.jsonObject(with: contentData) as? [String : Any] {
         return contentDataDict.mapValues { String(describing: $0) }
      }
      return nil
   }
}
