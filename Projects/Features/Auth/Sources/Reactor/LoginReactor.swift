// hankyeol-dev. Auth

import Foundation
import ReactorKit
import Domain
import Data

public final class LoginReactor: Reactor {
   private let authUsecase: AuthUsecaseType = AuthUsecase(authRepository: AuthRepository())
   private let userProvider: UserDefaultsProviderType = UserDefaultsProvider.shared
   public var initialState: State = .init()
   
   public struct State {
      var isLoading: Bool = false
      var isLogined: Bool = false
      @Pulse var email: String = ""
      @Pulse var password: String = ""
      
      var toLoginVO: LoginInputVO {
         .init(email: email, password: password)
      }
   }
   
   public enum Action {
      case tapLoginButton
      case textEmail(String)
      case textPassword(String)
   }
   
   public enum Mutation {
      case isLoading(Bool)
      case isLogined(Bool)
      case textEmail(String)
      case textPassword(String)
   }
   
   deinit { print(#function) }
}

extension LoginReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .tapLoginButton:
         let loginInput: LoginInputVO = initialState.toLoginVO
         return .concat([
            .just(.isLoading(true)),
            authUsecase.login(with: loginInput)
               .map({ result in
                  switch result {
                  case let .success(isLogined):
                     return isLogined
                  case .failure:
                     return false
                  }
               })
               .asObservable()
               .map(Mutation.isLogined),
            .just(.isLoading(false))
         ])
      case let .textEmail(email):
         return .just(.textEmail(email))
      case let .textPassword(password):
         return .just(.textPassword(password))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .isLoading(isLoading):
         newState.isLoading = isLoading
      case let .isLogined(isLogined):
         newState.isLogined = isLogined
      case let .textEmail(email):
         newState.email = email
      case let .textPassword(password):
         newState.password = password
      }
      initialState = newState
      return newState
   }
}
