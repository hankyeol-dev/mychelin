// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol UserUsecaseType: CommonUsecaseType {
   func getMe() -> Single<Result<MeProfileVO, NetworkErrors>>
}

public struct UserUsecase: UserUsecaseType {
   private let userRepository: UserRepositoryType
   public let authRepository: AuthRepositoryType
   public init(authRepository: AuthRepositoryType, userRepository: UserRepositoryType) {
      self.authRepository = authRepository
      self.userRepository = userRepository
   }
   
   public func getMe() -> Single<Result<MeProfileVO, NetworkErrors>> {
      return userRepository.getMe()
   }
}
