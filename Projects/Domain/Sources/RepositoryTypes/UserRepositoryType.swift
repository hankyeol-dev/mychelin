// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol UserRepositoryType {
   func getMe() -> Single<Result<MeProfileVO, NetworkErrors>>
   func getAnother(userId: String) -> Single<Result<MeProfileVO, NetworkErrors>>
   func editProfile(input: ProfileUpdateVO) -> Single<Result<ProfileUpdateVO, NetworkErrors>>
   func editProfileImage(input: ProfileImageUpdateVO) -> Single<Result<ProfileImageVO, NetworkErrors>>
   func searchUser(query: String) -> Single<Result<UserListVO, NetworkErrors>>
   func follow(userID: String, isFollow: Bool) -> Single<Bool>
}
