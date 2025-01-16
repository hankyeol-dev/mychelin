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
