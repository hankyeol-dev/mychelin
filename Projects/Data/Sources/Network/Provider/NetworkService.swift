// hankyeol-dev. Data

import Foundation

public struct NetworkService {
   private static let session: URLSession = .shared
   private static let decoder: JSONDecoder = .init()
   
   public static func request<T: Decodable>(
      router: RouterProtocol,
      of: T.Type
   ) async throws -> T {
      let request = try router.asURLRequest()
      let (data, res) = try await session.data(for: request)
      
      guard let res = res as? HTTPURLResponse else {
         throw NetworkError.invalidResponse
      }
      
      guard res.statusCode == 200 else {
         print(res.statusCode)
         throw handlerError(res.statusCode)
      }
      
      do {
         return try decoder.decode(T.self, from: data)
      } catch {
         print(error)
         throw NetworkError.noData
      }
   }
}

extension NetworkService {
   private static func handlerError(_ errorCode: Int) -> NetworkError {
      return NetworkError.validateErrorCode(errorCode)
   }
}
