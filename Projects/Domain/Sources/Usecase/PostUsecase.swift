// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostUsecaseType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>>
   func getCuraitonPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>>
   
   func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>>
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
   public func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>> {
      return postRepository.getCuration(curationId: curationId)
   }
   public func getCuraitonPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>> {
      return postRepository.getCuraitonPosts(query: query)
   }
}

// MARK: POST
extension PostUsecase {
   public func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>> {
      return postRepository.createCuration(input: input)
   }
}
