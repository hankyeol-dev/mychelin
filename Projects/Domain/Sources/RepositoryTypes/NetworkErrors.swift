// hankyeol-dev. Domain

import Foundation

public enum NetworkErrors: Error {
   case unknown
   
   case noNetwork
   case noToken
   case noData
   
   case tokenExpired
   
   public var toErrorMessage: String {
      switch self {
      case .unknown:
         return "알 수 없는 에러가 발생했습니다."
      case .noNetwork:
         return "네트워크 연결이 올바르지 않습니다."
      case .noToken:
         return "토큰이 없습니다."
      case .noData:
         return "데이터가 없습니다."
      case .tokenExpired:
         return "토큰이 만료되었습니다."
      }
   }
}
