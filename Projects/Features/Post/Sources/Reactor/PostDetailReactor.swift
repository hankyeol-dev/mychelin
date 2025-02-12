// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import Data

public final class PostDetailReactor: Reactor {
   public var initialState: State = .init()
   
   public struct State {
      var post: GetPostVO?
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case fetchPost
   }
   
   public init() {}
}

extension PostDetailReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .just(.fetchPost)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      
      switch mutation {
      case .fetchPost:
         newState.post = MockPost1
      }
      
      return newState
   }
}
