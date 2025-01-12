// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostUsecaseType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
}

public struct PostUsecase {
   private let postRepository: PostRepositoryType
   
   public init(postRepository: PostRepositoryType) {
      self.postRepository = postRepository
   }
}

extension PostUsecase: PostUsecaseType {
   public func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>> {
      return postRepository.getPosts(query: query)
   }
}
