// hankyeol-dev. Domain

import Foundation
import RxSwift

public protocol SearchUsecaseType {
   func nLocationSearch(query: String, start: Int) -> Single<Result<[NaverSearchVO], NetworkErrors>>
}

public struct SearchUsecase {
   private let searchRepository: SearchRepositoryType
   public init(searchRepository: SearchRepositoryType) {
      self.searchRepository = searchRepository
   }
}

extension SearchUsecase: SearchUsecaseType {
   public func nLocationSearch(query: String, start: Int) -> Single<Result<[NaverSearchVO], NetworkErrors>> {
      return searchRepository.nLocationSearch(query: query, start: start)
   }
}
