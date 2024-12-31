// hankyeol-dev. Data

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya
import Alamofire

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
      let provider = MoyaProvider<T>(session: Session(interceptor: NetworkProvider()))
      print(provider)
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
            if let res = error.response {
               print("failure:", res)
               print(try! res.map(CommonOutputType.self))
            }
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

extension NetworkProvider: RequestInterceptor {
   public func retry(_ request: Request,
                     for session: Session,
                     dueTo error: any Error,
                     completion: @escaping (RetryResult) -> Void) {
      guard let res = request.task?.response as? HTTPURLResponse,
            (res.statusCode == 403 || res.statusCode == 419)
      else {
         completion(.doNotRetryWithError(error))
         return
      }
      let refreshToken = UserDefaultsProvider.shared.getStringValue(.refreshToken)
      NetworkProvider.request(AuthRouter.refreshToken(refreshToken: refreshToken),
                              of: TokenOutputType.self) { result in
         switch result {
         case let .success(output):
            UserDefaultsProvider.shared.setStringValue(.accessToken, value: output.accessToken)
            UserDefaultsProvider.shared.setStringValue(.refreshToken, value: output.refreshToken)
            completion(.retry)
         case let .failure(error):
            print("retry: ", error)
            completion(.doNotRetryWithError(error))
         }
      }
   }
}
