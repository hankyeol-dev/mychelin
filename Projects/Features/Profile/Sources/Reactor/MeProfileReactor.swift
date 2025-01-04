// hankyeol-dev. Profile

import Foundation

import Domain
import Data

import ReactorKit
import RxDataSources

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
//      var editSection = MeProfileSection.Model(
//         model: .edit,
//         items: []
//      )
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case didLoad(Result<MeProfileVO, NetworkErrors>)
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
            newState.infoSection = .init(model: .info, items: [MeProfileSection.Items.info(vo)])
         case let .failure(error):
            newState.errorMessage = error.toErrorMessage
         }
      }
      
      return newState
   }
}
