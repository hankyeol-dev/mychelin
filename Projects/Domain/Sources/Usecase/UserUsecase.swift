// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol UserUsecaseType {
   func getMe() -> Single<Result<MeProfileVO, NetworkErrors>>
}

public struct UserUsecase {
   private let userRepository: UserRepositoryType
   public init(userRepository: UserRepositoryType) {
      self.userRepository = userRepository
   }
}

extension UserUsecase: UserUsecaseType {
   public func getMe() -> Single<Result<MeProfileVO, NetworkErrors>> {
      return userRepository.getMe()
   }
}

public protocol MockUserUsecaseType {
   func getMe() async -> Result<MeProfileVO, CommonError>
}

public struct MockUserUsecase: MockUserUsecaseType {
   private let repository: MockUserRepositoryType
   
   public init(repository: MockUserRepositoryType) {
      self.repository = repository
   }
   
   public func getMe() async -> Result<MeProfileVO, CommonError> {
      return await repository.getMe()
   }
}
