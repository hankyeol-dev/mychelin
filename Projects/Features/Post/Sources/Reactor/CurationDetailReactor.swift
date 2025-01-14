// hankyeol-dev. Post

import Foundation
import Domain
import Data
import ReactorKit

public final class CurationDetailReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let postUsecase: PostUsecaseType = PostUsecase(postRepository: PostRepository())
   
   public var initialState: State = .init()
   
   public struct State {
      var cateogry: String = ""
      var firstCategory: String = ""
      var next: String = ""
      var curationPosts: [GetPostVO] = []
   }
   
   public enum Action {
      case didLoad(curationId: String)
      case fetchCurationPosts(category: String, next: String)
   }
   
   public enum Mutation {
      case fetchCurationDetail(Result<GetCurationOutputVO, NetworkErrors>)
      case fetchCurationPosts(Result<GetCurationPostListVO, NetworkErrors>)
   }
}

extension CurationDetailReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .didLoad(curationId):
         return postUsecase.getCuration(curationId: curationId)
            .asObservable()
            .map({ .fetchCurationDetail($0) })
      case let .fetchCurationPosts(category, next):
         return postUsecase.getCuraitonPosts(query: .init(category: category, next: next))
            .asObservable()
            .map({ .fetchCurationPosts($0) })
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .fetchCurationDetail(result):
         switch result {
         case let .success(vo):
            newState.cateogry = vo.curationName
            newState.firstCategory = vo.curationFirstCategory
            action.onNext(.fetchCurationPosts(category: vo.curationName, next: ""))
         case let .failure(error): print(error)
         }
      case let .fetchCurationPosts(result):
         switch result {
         case let .success(vo):
            newState.next = vo.next
            newState.curationPosts = vo.data
         case let .failure(error): print(error)
         }
      }
      return newState
   }
}
