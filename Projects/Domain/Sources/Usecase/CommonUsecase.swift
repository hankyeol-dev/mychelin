// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol CommonUsecaseType {
   var authRepository: AuthRepositoryType { get }
   func refreshToken() -> Single<Bool>
}

extension CommonUsecaseType {
   public func refreshToken() -> Single<Bool> {
      return authRepository.refreshToken()
   }
}
