// hankyeol-dev. Post

import Foundation
import Common
import Domain
import ReactorKit

public final class WritePostCurationReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   public var initialState: State = .init()
   
   public struct State {
      let firstCategories: [FirstCategories] = FirstCategories.allCases.map({ $0 })
      var selectedFirstCategory: FirstCategories?
      var curationName: String = ""
   }
   
   public enum Action {
      case selectFirstCategory(Int)
      case setCurationName(String)
   }
   
   public enum Mutation {
      case setFirstCategory(Int)
      case setCurationName(String)
   }
}

extension WritePostCurationReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .selectFirstCategory(index):
         return .just(.setFirstCategory(index))
      case let .setCurationName(name):
         return .just(.setCurationName(name))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newstate = state
      switch mutation {
      case let .setFirstCategory(index):
         newstate.selectedFirstCategory = state.firstCategories[index]
      case let .setCurationName(name):
         newstate.curationName = name
      }
      return newstate
   }
}
