// hankyeol-dev. Data

import Foundation
import Domain

public enum NetworkError: Int, Error, CaseIterable {
   case invalidAccessToken = 401
   case invalidUserId = 403
   case expiredAccessToken = 419
   case invalidSecret = 420
   case invalidProductId = 421
   
   case overCallStack = 429
   case unknown = 444
   case serverError = 500
   
   case invalidURL = 1
   case invalidRequest = 2
   case invalidResponse = 3
   case noData = 4
}

extension NetworkError {
   public static func validateErrorCode(_ errorCode: Int) -> Self {
      return NetworkError(rawValue: errorCode) ?? .unknown
   }
   
   public func mapToCommonError() -> CommonError {
      switch self {
      case .invalidAccessToken: .error(message: "재로그인이 필요합니다.")
      case .invalidUserId: .error(message: "유저 아이디가 일치하지 않습니다.")
      case .expiredAccessToken: .error(message: "토큰 갱신이 필요합니다.")
      case .invalidSecret: .error(message: "고유 키 값이 일치하지 않습니다.")
      case .invalidProductId: .error(message: "ProductId 값이 일치하지 않습니다.")
      case .overCallStack: .error(message: "너무 많은 요청이 들어왔습니다.")
      case .unknown: .error(message: "알 수 없는 에러가 발생했습니다.")
      case .serverError: .error(message: "서버 에러가 발생했습니다.")
      case .noData: .error(message: "데이터를 찾을 수 없습니다.")
      default: .error(message: "라우터 요청에서 문제가 있습니다.")
      }
   }
}
