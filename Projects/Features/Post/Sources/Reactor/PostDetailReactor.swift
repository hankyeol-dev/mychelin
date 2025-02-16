// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import Data
import RxDataSources

public final class PostDetailReactor: Reactor {
   private var postId: String
   public var initialState: State = .init()
   
   public struct State {
      var post: GetPostVO?
      var postSection = PostDetailSection.Model(model: .post, items: [])
      var divierSection = PostDetailSection.Model(model: .divider, items: [])
      var commentSection = PostDetailSection.Model(model: .comment, items: [])
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case fetchPost
   }
   
   public init(_ postId: String) {
      self.postId = postId
   }
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
         newState.postSection = .init(model: .post,
                                      items: [.post(MockPost1)])
         newState.divierSection = .init(model: .divider, items: [.divider])
         newState.commentSection = .init(model: .comment, items: [.comment(MockPostComment1), .comment(MockPostComment2)])
      }
      
      return newState
   }
}
