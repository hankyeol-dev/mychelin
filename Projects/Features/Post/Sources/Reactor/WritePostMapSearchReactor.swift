// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import Data

public final class WritePostMapSearchReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let searchUsecase: SearchUsecaseType = SearchUsecase(searchRepository: SearchRepository())
   public var initialState: State = .init()
   
   public struct State {
      var searched: [NaverSearchVO] = []
   }
   
   public enum Action {
      case query(String)
      case empty
   }
   
   public enum Mutation {
      case searching(Result<[NaverSearchVO], NetworkErrors>)
      case empty
   }
}

extension WritePostMapSearchReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .query(query):
         searchUsecase.nLocationSearch(query: query)
            .asObservable()
            .map({ .searching($0) })
      case .empty: .just(.empty)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .searching(result):
         switch result {
         case let .success(output):
            newState.searched = output
         case .failure(let failure):
            print("reactor: ", failure)
         }
      case .empty:
         newState.searched = []
      }
      return newState
   }
}
