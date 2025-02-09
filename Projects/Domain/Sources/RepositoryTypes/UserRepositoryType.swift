// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol UserRepositoryType {
   func getMe() -> Single<Result<MeProfileVO, NetworkErrors>>
}

public protocol MockUserRepositoryType {
   func getMe() async -> Result<MeProfileVO, CommonError>
}
