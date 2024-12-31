// hankyeol-dev. Data

import Foundation
import Domain
import RxSwift

public struct UserRepository {
   private let disposeBag: DisposeBag = .init()
   private let userProvider: UserDefaultsProvider = .shared
   
   public init() {}
}

extension UserRepository: UserRepositoryType {
   public func getMe() -> Single<Result<MeProfileVO, NetworkErrors>> {
      return Single.create { single in
         NetworkProvider.request(UserRouter.me, of: ProfileOutputType.self) { result in
            switch result {
            case let .success(output):
               single(.success(.success(output.toVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
}
