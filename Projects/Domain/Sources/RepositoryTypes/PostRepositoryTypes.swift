// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostRepositoryType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   func getPost(postId: String) -> Single<Result<GetPostVO, NetworkErrors>>
   func getPostsByCategory(query: GetPostQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
   
   func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>>
   func getCurations() -> Single<Result<GetPostListVO, NetworkErrors>>
   func getCurationPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>>
   
   func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>>
}

