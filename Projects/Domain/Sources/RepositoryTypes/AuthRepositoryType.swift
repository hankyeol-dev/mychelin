// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol AuthRepositoryType {
   func join(with joinInput: JoinInputVO) -> Single<Result<Bool, NetworkErrors>>
   func login(with loginInput: LoginInputVO) -> Single<Result<Bool, NetworkErrors>>
   func refreshToken() -> Single<Bool>
}

public protocol MockAuthRepositoryType {
   func login(with loginInput: LoginInputVO) async -> Result<Bool, CommonError>
}
