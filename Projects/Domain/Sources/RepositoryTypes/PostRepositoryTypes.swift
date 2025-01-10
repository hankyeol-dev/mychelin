// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol PostRepositoryType {
   func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>>
}
