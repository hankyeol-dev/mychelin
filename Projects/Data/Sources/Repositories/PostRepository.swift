// hankyeol-dev. Data

import Foundation
import Domain

import RxSwift
import Moya

public struct PostRepository {
   private let disposeBag: DisposeBag = .init()
   private let userProvider: UserDefaultsProvider = .shared
   
   public init() {}
}

extension PostRepository: PostRepositoryType {
   public func getPosts(query: GEOSearchQueryVO) -> Single<Result<GetPostListVO, NetworkErrors>> {
      return Single.create { single in
         
         let query: SearchGEOQueryType = .init(
            category: query.category,
            longitude: query.longitude,
            latitude: query.latitude,
            maxDistance: query.maxDistance
         )
         
         NetworkProvider.request(
            SearchRouter.searchByGeoLocation(query: query),
            of: SearchGEOOutputType.self
         ) { result in
            switch result {
            case let .success(output):
               print(output)
               single(.success(.success(output.toGetPostListVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         
         return Disposables.create()
      }
   }
}
