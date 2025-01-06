// hankyeol-dev. Profile

import Foundation

import Domain
import Data

import ReactorKit
import RxDataSources
import UIKit

public final class MeProfileReactor: @preconcurrency Reactor {
   private let disposeBag: DisposeBag = .init()
   private let userUsecase: UserUsecaseType = UserUsecase(
      authRepository: AuthRepository(),
      userRepository: UserRepository())
   
   public var initialState: State = .init()
   
   public struct State {
      var profileObject: MeProfileVO?
      var errorMessage: String?
      var infoSection = MeProfileSection.Model(
         model: .info,
         items: []
      )
      var editSection = MeProfileSection.Model(
         model: .edit,
         items: []
      )
      var divider = MeProfileSection.Model(
         model: .divider,
         items: []
      )
      var postSection = MeProfileSection.Model(
         model: .post,
         items: []
      )
      var logoutSection = MeProfileSection.Model(
         model: .logout,
         items: []
      )
   }
   
   public enum Action {
      case didLoad
      case tapMenu(indexPath: [Int])
   }
   
   public enum Mutation {
      case didLoad(Result<MeProfileVO, NetworkErrors>)
      case tapMenu(indexPath: [Int])
   }
   
   deinit { print(#function) }
}

extension MeProfileReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         userUsecase.getMe()
            .asObservable()
            .map({ Mutation.didLoad($0) })
      case let .tapMenu(indexPath):
            .just(Mutation.tapMenu(indexPath: indexPath))
      }
   }
   
   @MainActor
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      
      switch mutation {
      case let .didLoad(result):
         switch result {
         case let .success(vo):
            newState.profileObject = vo
            newState.infoSection = .init(model: .info, items: [.info(vo)])
            newState.divider = .init(model: .divider, items: [.divider])
            newState.editSection = .init(model: .edit,
                                         items: [.edit(.init(icon: .id, label: "내 정보 관리"))])
            newState.postSection = .init(model: .post,
                                         items: [
                                          .post(.init(icon: .posts, label: "내가 작성한 글")),
                                          .post(.init(icon: .like, label: "내가 좋아요한 글"))
                                         ])
            newState.logoutSection = .init(model: .logout,
                                           items: [.logout(.init(icon: .xMark, label: "로그아웃"))])
         case let .failure(error):
            newState.errorMessage = error.toErrorMessage
         }
      case let .tapMenu(indexPath):
         newState
      }
      return newState
   }
}
