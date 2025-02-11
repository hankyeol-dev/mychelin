// hankyeol-dev. Data

import Foundation
import Domain
import RxSwift

public struct SearchRepository: SearchRepositoryType {
   public init() {}
   
   public func nLocationSearch(query: String, start: Int = 1) -> Single<Result<[NaverSearchVO], NetworkErrors>> {
      return Single.create { single in
         NetworkProvider.nSearch(query, start) { result in
            switch result {
            case let .success(output):
               single(.success(.success(output.items.map({ $0.toVO }))))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
}

public struct MockSearchRepository: MockSearchRepositoryType, DefaultRepositoryType {
   public init() {}
   
   public func kLocationSearch(query: String) async -> Result<KSearchVO, CommonError> {
      let result = await request(KSearchRouter.kSearch(query: query), of: KSearchOutput.self)
      switch result {
      case .success(let success):
         return .success(success.toVO)
      case .failure(let failure):
         print(failure)
         return .failure(.error(message: "k search error"))
      }
   }
}
