// hankyeol-dev. Data

import Foundation
import Domain
import RxSwift

public struct AuthRepository {
   private let disposeBag: DisposeBag = .init()
   private let userProvider: UserDefaultsProvider = .shared
   
   public init() {}
}

extension AuthRepository: AuthRepositoryType {
   public func join(
      with joinInput: JoinInputVO
   ) -> Single<Result<Bool, NetworkErrors>> {
      return Single.create { single in
         let dto: JoinInputType = .init(email: joinInput.email,
                                        password: joinInput.password,
                                        nick: joinInput.nick)
//         NetworkProvider.request(AuthRouter.join(dto), of: JoinOutputType.self) { result in
//            switch result {
//            case let .success(output):
//               userProvider.setStringValue(.userId, value: output.userId)
//               single(.success(.success(true)))
//            case let .failure(error):
//               single(.success(.failure(error)))
//            }
//         }
         single(.success(.success(true)))
         return Disposables.create()
      }
   }
   
   public func login(
      with loginInput: LoginInputVO
   ) -> Single<Result<Bool, NetworkErrors>> {
      return Single.create { single in
         let dto: LoginInputType = .init(email: loginInput.email,
                                         password: loginInput.password)
         NetworkProvider.request(AuthRouter.login(dto), of: LoginOutputType.self) { result in
            switch result {
            case let .success(output):
               userProvider.setBoolValue(.isLogined, value: true)
               userProvider.setStringValue(.userId, value: output.userId)
               userProvider.setStringValue(.accessToken, value: output.accessToken)
               userProvider.setStringValue(.refreshToken, value: output.refreshToken)
               single(.success(.success(true)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
   
   public func refreshToken() -> Single<Bool> {
      return Single.create { single in
         let refreshToken: String = userProvider.getStringValue(.refreshToken)
         NetworkProvider.request(
            AuthRouter.refreshToken(refreshToken: refreshToken),
            of: TokenOutputType.self) { result in
               switch result {
               case let .success(output):
                  userProvider.setStringValue(.accessToken, value: output.accessToken)
                  userProvider.setStringValue(.refreshToken, value: output.refreshToken)
                  userProvider.setBoolValue(.isLogined, value: true)
                  single(.success(true))
               case .failure:
                  single(.success(false))
               }
            }
         return Disposables.create()
      }
   }
}
