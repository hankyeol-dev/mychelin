
import Foundation
import RxSwift

public protocol AuthUsecaseType: CommonUsecaseType {
   func join(with joinInput: JoinInputVO) -> Single<Result<Bool, NetworkErrors>>
   func login(with loginInput: LoginInputVO) -> Single<Result<Bool, NetworkErrors>>
}

public struct AuthUsecase: AuthUsecaseType {
   public let authRepository: AuthRepositoryType
   
   public init(authRepository: AuthRepositoryType) {
      self.authRepository = authRepository
   }

   public func join(with joinInput: JoinInputVO) -> Single<Result<Bool, NetworkErrors>> {
      return authRepository.join(with: joinInput)
   }
   
   public func login(with loginInput: LoginInputVO) -> Single<Result<Bool, NetworkErrors>> {
      return authRepository.login(with: loginInput)
   }
}
