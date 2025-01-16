// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol SearchRepositoryType {
   func nLocationSearch(query: String, start: Int) -> Single<Result<[NaverSearchVO], NetworkErrors>>
}
