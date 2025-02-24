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
   
   public func getAnother(userId: String) -> Single<Result<MeProfileVO, NetworkErrors>> {
      return Single.create { single in
         let router: UserRouter = .other(userId: userId)
         
         NetworkProvider.request(router, of: ProfileOutputType.self) { result in
            switch result {
            case .success(let success):
               single(.success(.success(success.toVO)))
            case .failure(let failure):
               single(.success(.failure(failure)))
            }
         }
         
         return Disposables.create()
      }
   }
   
   public func editProfile(input: ProfileUpdateVO) -> Single<Result<ProfileUpdateVO, NetworkErrors>> {
      let router: UserRouter = .meEdit(input: .init(nick: input.nick,
                                                    phoneNum: input.phoneNum,
                                                    info1: nil,
                                                    info2: nil,
                                                    info3: nil,
                                                    info4: nil,
                                                    info5: nil))
      return Single.create { single in
         NetworkProvider.request(router, of: ProfileOutputType.self) { result in
            switch result {
            case .success(let success):
               single(.success(.success(success.toUpdatedProfileVO)))
            case .failure(let failure):
               single(.success(.failure(failure)))
            }
         }
         return Disposables.create()
      }
   }
   
   public func editProfileImage(input: ProfileImageUpdateVO) -> Single<Result<ProfileImageVO, NetworkErrors>> {
      let router: UserRouter = .meProfileImageEdit(input: .init(profile: input.profile))
      return Single.create { single in
         NetworkProvider.request(router, of: ProfileOutputType.self) { result in
            switch result {
            case .success(let success):
               single(.success(.success(success.toImageVO)))
            case .failure(let failure):
               single(.success(.failure(failure)))
            }
         }
         
         return Disposables.create()
      }
   }
   
   public func searchUser(query: String) -> Single<Result<UserListVO, NetworkErrors>> {
      let router: UserRouter = .search(nick: query)
      return Single.create { single in
         NetworkProvider.request(router, of: UserListOutput.self) { result in
            switch result {
            case .success(let success):
               single(.success(.success(success.toUserListVO)))
            case .failure(let failure):
               single(.success(.failure(failure)))
            }
         }
         
         return Disposables.create()
      }
   }
   
   public func follow(userID: String, isFollow: Bool) -> Single<Bool> {
      let router: UserRouter = isFollow ? .follow(userId: userID) : .unFollow(userId: userID)
      return Single.create { single in
         NetworkProvider.request(router, of: FollowOutputType.self) { result in
            switch result {
            case .success:
               single(.success(true))
            case .failure:
               single(.success(false))
            }
         }
         return Disposables.create()
      }
   }
}

