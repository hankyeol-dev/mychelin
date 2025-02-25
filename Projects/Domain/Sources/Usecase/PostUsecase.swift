// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostUsecaseType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   func getPost(postId: String) -> Single<Result<GetPostVO, NetworkErrors>>
   func getPostsByCategory(query: GetPostQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   
   func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>>
   func getCurations() -> Single<Result<GetPostListVO, NetworkErrors>>
   func getCurationPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>>
   
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
   public func getPost(postId: String) -> Single<Result<GetPostVO, NetworkErrors>> {
      return postRepository.getPost(postId: postId)
   }
   public func getPostsByCategory(query: GetPostQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>> {
      return postRepository.getPostsByCategory(query: query)
   }
   
   public func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>> {
      return postRepository.getCuration(curationId: curationId)
   }
   public func getCurations() -> Single<Result<GetPostListVO, NetworkErrors>> {
      return postRepository.getCurations()
   }
   public func getCurationPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>> {
      return postRepository.getCurationPosts(query: query)
   }
}

// MARK: POST
extension PostUsecase {
   public func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>> {
      return postRepository.createCuration(input: input)
   }
}
