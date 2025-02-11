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

public protocol MockSearchUsecaseType {
   func kLocationSearch(query: String) async -> Result<KSearchVO, CommonError>
}

public struct MockSearchUsecase: MockSearchUsecaseType {
   private let repository: MockSearchRepositoryType
   
   public init(repository: MockSearchRepositoryType) {
      self.repository = repository
   }
   
   public func kLocationSearch(query: String) async -> Result<KSearchVO, CommonError> {
      return await repository.kLocationSearch(query: query)
   }
}


