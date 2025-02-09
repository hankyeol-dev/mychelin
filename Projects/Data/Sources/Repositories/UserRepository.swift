// hankyeol-dev. Data

import Foundation
import Domain

import RxSwift
import Moya

public struct UserRepository {
   private let disposeBag: DisposeBag = .init()
   private let userProvider: UserDefaultsProvider = .shared
   
   public init() {}
}

extension UserRepository: UserRepositoryType {   
   public func getMe() -> Single<Result<MeProfileVO, NetworkErrors>> {
      return Single.create { single in
         let router: UserRouter = .me
         
         NetworkProvider.request(router, of: ProfileOutputType.self) { result in
            switch result {
            case let .success(profile):
               single(.success(.success(profile.toVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         
         return Disposables.create()
      }
   }
}

public struct MockUserRepository: MockUserRepositoryType, DefaultRepositoryType {
   public init() {}
   
   public func getMe() async -> Result<MeProfileVO, CommonError> {
      let output = await request(MockUserRouter.me, of: ProfileOutputType.self)
      switch output {
      case .success(let success):
         return .success(success.toVO)
      case .failure(let failure):
         return .failure(failure.mapToCommonError())
      }
   }
}
