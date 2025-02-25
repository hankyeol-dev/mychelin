// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol UserUsecaseType {
   func getMe() -> Single<Result<MeProfileVO, NetworkErrors>>
   func getAnother(userId: String) -> Single<Result<MeProfileVO, NetworkErrors>>
   func editProfile(input: ProfileUpdateVO) -> Single<Result<ProfileUpdateVO, NetworkErrors>>
   func editProfileImage(input: ProfileImageUpdateVO) -> Single<Result<ProfileImageVO, NetworkErrors>>
   func searchUser(query: String) -> Single<Result<UserListVO, NetworkErrors>>
   func follow(userID: String, isFollow: Bool) -> Single<Bool>
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
   
   public func getAnother(userId: String) -> Single<Result<MeProfileVO, NetworkErrors>> {
      return userRepository.getAnother(userId: userId)
   }
   
   public func editProfile(input: ProfileUpdateVO) -> Single<Result<ProfileUpdateVO, NetworkErrors>> {
      return userRepository.editProfile(input: input)
   }
   
   public func editProfileImage(input: ProfileImageUpdateVO) -> Single<Result<ProfileImageVO, NetworkErrors>> {
      return userRepository.editProfileImage(input: input)
   }
   
   public func searchUser(query: String) -> Single<Result<UserListVO, NetworkErrors>> {
      return userRepository.searchUser(query: query)
   }
   
   public func follow(userID: String, isFollow: Bool) -> Single<Bool> {
      return userRepository.follow(userID: userID, isFollow: isFollow)
   }
}
