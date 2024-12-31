// hankyeol-dev. Profile

import Foundation

import Domain
import Data

import ReactorKit

public final class ProfileReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let userUsecase: UserUsecaseType = UserUsecase(
      authRepository: AuthRepository(),
      userRepository: UserRepository())
   
   public var initialState: State = .init()
   
   public struct State {
      var profileObject: MeProfileVO?
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case didLoad(Result<MeProfileVO, NetworkErrors>)
   }
   
   deinit { print(#function) }
}

extension ProfileReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         userUsecase.getMe()
            .asObservable()
            .map(Mutation.didLoad)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      
      switch mutation {
      case let .didLoad(result):
         switch result {
         case let .success(profile):
            newState.profileObject = profile
         case let .failure(error):
            UserDefaultsProvider.shared.setBoolValue(.isLogined, value: false)
         }
      }
      
      return newState
   }
}
