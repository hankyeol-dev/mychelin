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
   public func getCuration(curationId: String) -> Single<Result<GetCurationOutputVO, NetworkErrors>> {
      return Single.create { single in
         NetworkProvider.request(PostRouter.getPost(postId: curationId),
                                 of: PostOutputType.self) { result in
            switch result {
            case let .success(output):
               single(.success(.success(output.toGetCurationOutputVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
   public func getCuraitonPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>> {
      return Single.create { single in
         let query: GetPostQueryType = .init(next: query.next, category: query.category)
         NetworkProvider.request(PostRouter.getPosts(query: query),
                                 of: PostListOutputType.self) { result in
            switch result {
            case let .success(output):
               single(.success(.success(output.toGetCurationPostListVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
}

extension PostRepository {
   public func createCuration(input: CreateCurationInputVO) -> Single<Result<CreateCurationOutputVO, NetworkErrors>> {
      return Single.create { single in
         let input: PostInputType = .init(category: input.curationName,
                                          title: input.firstCategory,
                                          content: "",
                                          content1: String(input.curationColorIndex),
                                          content2: String(input.curationMakePublic))
         NetworkProvider.request(
            PostRouter.uploadPost(input: input),
            of: PostOutputType.self
         ) { result in
            switch result {
            case let .success(output):
               print("output - createCuration: ", output)
               single(.success(.success(output.toCreateCurationOutputVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         
         return Disposables.create()
      }
   }
}
