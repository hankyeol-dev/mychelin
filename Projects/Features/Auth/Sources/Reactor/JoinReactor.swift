// hankyeol-dev. Auth

import Foundation
import ReactorKit
import Domain
import Data

public final class JoinReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let authUsecase: AuthUsecaseType = AuthUsecase(authRepository: AuthRepository())
   public var initialState: State = .init()
   
   public struct State {
      var isLoading: Bool = false
      @Pulse var isLogined: Bool = false
      @Pulse var email: String = ""
      @Pulse var password: String = ""
      @Pulse var nick: String = ""
      
      var toJoinVO: JoinInputVO {
         .init(email: email, password: password, nick: nick)
      }
   }
   
   public enum Action {
      case textEmail(String)
      case textPassword(String)
      case textNick(String)
      case tapJoinButton
   }
   
   public enum Mutation {
      case isLoading(Bool)
      case textEmail(String)
      case textPassword(String)
      case textNick(String)
      case tapJoinButton(Bool)
   }
   
   deinit { print(#function) }
}

extension JoinReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .textEmail(email):
         return .just(.textEmail(email))
      case let .textPassword(pw):
         return .just(.textPassword(pw))
      case let .textNick(nick):
         return .just(.textNick(nick))
      case .tapJoinButton:
         let input: JoinInputVO = .init(
            email: initialState.email,
            password: initialState.password,
            nick: initialState.nick)
         return .concat([
            .just(.isLoading(true)),
            authUsecase.join(with: input)
               .map({
                  switch $0 {
                  case let .success(isJoined):
                     return isJoined
                  case .failure:
                     return false
                  }
               })
               .asObservable()
               .map(Mutation.tapJoinButton),
            .just(.isLoading(false))
         ])
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      
      switch mutation {
      case let .isLoading(loading):
         newState.isLoading = loading
      case let .textEmail(email):
         newState.email = email
      case let .textPassword(pw):
         newState.password = pw
      case let .textNick(nick):
         newState.nick = nick
      case let .tapJoinButton(success):
         newState.isLogined = success
      }
      print(initialState)
      initialState = newState
      return newState
   }
}
