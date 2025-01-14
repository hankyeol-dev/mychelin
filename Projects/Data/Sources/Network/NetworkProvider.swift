// hankyeol-dev. Data

import Foundation
import Domain

import RxSwift
import Moya
import RxMoya
import Kingfisher

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
            do {
               completion(.success(try res.map(D.self)))
            } catch {
               print("request - catch", error)
               completion(.failure(.noData))
            }
         case let .failure(error):
            let errors = errorHandler(error)
            switch errors {
            case .allTokensExpired:
               print("request - allTokenExpired")
               let autoLoginInput: LoginInputType = .init(email: env.tempEmail,
                                                          password: env.tempPW)
               request(
                  AuthRouter.login(autoLoginInput),
                  of: LoginOutputType.self
               ) { result in
                  switch result {
                  case let .success(token):
                     UserDefaultsProvider.shared.setStringValue(.accessToken, value: token.accessToken)
                     UserDefaultsProvider.shared.setStringValue(.refreshToken, value: token.refreshToken)
                     KingfisherManager.shared.setImageRequestHeader()
                     request(router, of: output, completion)
                  case let .failure(error):
                     completion(.failure(error))
                  }
               }
            case .tokenExpired:
               let refreshToken = UserDefaultsProvider.shared.getStringValue(.refreshToken)
               request(
                  AuthRouter.refreshToken(refreshToken: refreshToken),
                  of: TokenOutputType.self
               ) { result in
                  switch result {
                  case let .success(token):
                     UserDefaultsProvider.shared.setStringValue(.accessToken, value: token.accessToken)
                     UserDefaultsProvider.shared.setStringValue(.refreshToken, value: token.refreshToken)
                     KingfisherManager.shared.setImageRequestHeader()
                     request(router, of: output, completion)
                  case let .failure(error):
                     completion(.failure(error))
                  }
               }
            default :
               completion(.failure(errors))
            }
         }
      }
   }
   
   private static func errorHandler(_ error: MoyaError) -> NetworkErrors {
      guard let res = error.response else {
         print("errorHandler - MoyaError: ", error)
         return .unknown
      }
      print("errorHandler - response: ", res)
      switch res.statusCode {
      case 401, 418:
         return .allTokensExpired
      case 419:
         return .tokenExpired
      default:
         return .unknown
      }
   }
}
