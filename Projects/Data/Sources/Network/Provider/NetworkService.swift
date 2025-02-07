// hankyeol-dev. Data

import Foundation

//public struct NetworkService {
//   private static let session: URLSession = .shared
//   private static let decoder: JSONDecoder = .init()
//   
//   public static func request<T: Decodable>(
//      router: RouterProtocol,
//      of: T.Type
//   ) async throws -> T {
//      
//      let request = try await router.asURLRequest()
//      let (data, res) = try await session.data(for: request)
//      
//      guard let res = res as? HTTPURLResponse,
//            res.statusCode == 200
//      else {
//         throw handleErrorOutput(data)
//      }
//      
//      do {
//         return try decoder.decode(T.self, from: data)
//      } catch {
//         throw NetworkErrors.error(message: .E00)
//      }
//   }
//   
//   public static func requestImage(router: RouterProtocol) async throws -> Data? {
//      let request = try await router.asURLRequest()
//      let (data, res) = try await session.data(for: request)
//      
//      guard let res = res as? HTTPURLResponse, res.statusCode != 400 else {
//         throw handleErrorOutput(data)
//      }
//      
//      return data
//   }
//   
//   private static func handleErrorOutput(_ data : Data) -> NetworkError {
//      // MARK: response의 응답코드가 400인 경우, errorCode 값을 확인하여 에러 핸들링
//      do {
//         let errorCode = try decoder.decode(ErrorOutputType.self, from: data).errorCode
//         print("errorCode: \(errorCode)")
//         if let type = NetworkErrorTypes(rawValue: errorCode) {
//            return .error(message: type)
//         } else {
//            return .error(message: .E00)
//         }
//      } catch {
//         return .error(message: .E00)
//      }
//   }
//}
