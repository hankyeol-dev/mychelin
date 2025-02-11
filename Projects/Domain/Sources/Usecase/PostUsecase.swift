// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostUsecaseType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
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

public protocol MockPostUsecaseType {
   func uploadImages(input: UploadFilesInputVO) async -> Result<UploadFilesOutputVO, CommonError>
   func uploadPost(input: UploadPostInputVO) async -> Result<UploadPostOutputVO, CommonError>
   func getPost(postId: String) async -> Result<GetPostVO, CommonError>
   func getPosts(query: GetPostQueryVO) async -> Result<GetPostListVO, CommonError>
   func getPostsByHashtag(query: GetPostByHashtagVO) async -> Result<GetPostListVO, CommonError>
   func getPostsByLocation(query: GEOSearchQueryVO) async -> Result<GetPostListVO, CommonError>
}

public struct MockPostUsecase: MockPostUsecaseType {
   private let repository: MockPostRepositoryType
   
   public init(repository: MockPostRepositoryType) {
      self.repository = repository
   }
   
   public func uploadImages(input: UploadFilesInputVO) async -> Result<UploadFilesOutputVO, CommonError> {
      return await repository.uploadImages(input: input)
   }
   
   public func uploadPost(input: UploadPostInputVO) async -> Result<UploadPostOutputVO, CommonError> {
      return await repository.uploadPost(input: input)
   }
   
   public func getPost(postId: String) async -> Result<GetPostVO, CommonError> {
      return await repository.getPost(postId: postId)
   }
   
   public func getPosts(query: GetPostQueryVO) async -> Result<GetPostListVO, CommonError> {
      return await repository.getPosts(query: query)
   }
   
   public func getPostsByHashtag(query: GetPostByHashtagVO) async -> Result<GetPostListVO, CommonError> {
      return await repository.getPostsByHashtag(query: query)
   }
   
   public func getPostsByLocation(query: GEOSearchQueryVO) async -> Result<GetPostListVO, CommonError> {
      return await repository.getPostsByLocation(query: query)
   }
}
