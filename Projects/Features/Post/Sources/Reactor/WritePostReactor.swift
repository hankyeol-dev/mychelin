// hankyeol-dev. Post

import Foundation
import Domain
import Data
import ReactorKit

public final class WritePostReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let postUsecase: PostUsecaseType = PostUsecase(postRepository: PostRepository())
   private let userId: String = UserDefaultsProvider.shared.getStringValue(.userId)
     
   public var initialState: State = .init()
   
   public struct State {
      var curations: [String] = ["선택 안함"]
      var selectedCuration: String = ""
   }
   
   public enum Action {
      case didLoad
      case selectCuration(String)
   }
   
   public enum Mutation {
      case fetchCurations(Result<GetPostListVO, NetworkErrors>)
      case setCuration(String)
   }
}

extension WritePostReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .concat([
            postUsecase.getCurations()
               .asObservable()
               .map({ .fetchCurations($0) })
         ])
      case let .selectCuration(curation):
         return .just(.setCuration(curation))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .fetchCurations(output):
         switch output {
         case let .success(vo):
            newState.curations.append(contentsOf: vo.data.map({ $0.title }))
         case let .failure(error):
            print(error)
         }
      case let .setCuration(curation):
         newState.selectedCuration = curation
      }
      return newState
   }
}
