// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import RxDataSources

public final class PostDetailReactor: Reactor {
   private var postId: String
   private let postUsecase: MockPostUsecaseType

   public var initialState: State = .init()
   
   public struct State {
      var post: GetPostVO?
      var postSection = PostDetailSection.Model(model: .post, items: [])
      var divierSection = PostDetailSection.Model(model: .divider, items: [])
      var commentSection = PostDetailSection.Model(model: .comment, items: [])
      var commentSectionTitle = PostDetailSection.Model(model: .title, items: [])
      var errorMsg: String?
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case fetchPost
   }
   
   public init(_ postId: String, postUsecase: MockPostUsecaseType) {
      self.postId = postId
      self.postUsecase = postUsecase
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
         let result = postUsecase.getPost(postId: postId)
         switch result {
         case let .success(post):
            newState.post = post
            newState.postSection = .init(model: .post, items: [.post(post)])
            newState.divierSection = .init(model: .divider, items: [.divider])
            newState.commentSectionTitle = .init(model: .title, items: [.title("댓글")])
            
         case let .failure(error):
            newState.errorMsg = error.toMessage
         }
      }
      
      return newState
   }
}
