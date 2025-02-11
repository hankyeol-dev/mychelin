// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostRepositoryType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>>
   func getCurations() -> Single<Result<GetPostListVO, NetworkErrors>>
   func getCurationPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>>
   
   func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>>
}

public protocol MockPostRepositoryType {
   func uploadImages(input: UploadFilesInputVO) async -> Result<UploadFilesOutputVO, CommonError>
   func uploadPost(input: UploadPostInputVO) async -> Result<UploadPostOutputVO, CommonError>
   func getPost(postId: String) async -> Result<GetPostVO, CommonError>
   func getPosts(query: GetPostQueryVO) async -> Result<GetPostListVO, CommonError>
   func getPostsByHashtag(query: GetPostByHashtagVO) async -> Result<GetPostListVO, CommonError>
   func getPostsByLocation(query: GEOSearchQueryVO) async -> Result<GetPostListVO, CommonError>
}
