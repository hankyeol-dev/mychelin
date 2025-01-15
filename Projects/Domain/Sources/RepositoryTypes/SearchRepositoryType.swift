// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol SearchRepositoryType {
   func nLocationSearch(query: String) -> Single<Result<[NaverSearchVO], NetworkErrors>>
}
