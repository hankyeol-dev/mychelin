// hankyeol-dev. Data

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya

public protocol NetworkProviderType {
   static func request<T: RouterType, D: Decodable>(
      _ router: T,
      of output: D.Type,
      _ completion: @escaping (Result<D, NetworkErrors>) -> Void)
}

public struct NetworkProvider: NetworkProviderType {
   public static func request<T: RouterType, D: Decodable>(
      _ router: T,
      of output: D.Type,
      _ completion: @escaping (Result<D, NetworkErrors>) -> Void
   ) {
      let provider = MoyaProvider<T>()
      provider.request(router) {
         switch $0 {
         case let .success(res):
            let response = responseHandler(res, D.self)
            switch response {
            case let .success(output):
               completion(.success(output))
            case let .failure(error):
               completion(.failure(error))
            }
         case let .failure(error):
            completion(.failure(errorHandler(error)))
         }
      }
   }
   
   private static func responseHandler<D: Decodable>(
      _ res: Response,
      _ outputType: D.Type
   ) -> Result<D, NetworkErrors> {
      switch res.statusCode {
      case 419:
         return .failure(.tokenExpired)
      default:
         do {
            return .success(try res.map(D.self))
         } catch {
            return .failure(.noData)
         }
      }
   }
   
   private static func errorHandler(_ error: MoyaError) -> NetworkErrors {
      return error.errorCode == 6
      ? .noNetwork
      : .unknown
   }
}
