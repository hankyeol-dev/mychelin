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
   public func getCurations() -> Single<Result<GetPostListVO, NetworkErrors>> {
      return Single.create { single in
         NetworkProvider.request(
            PostRouter.getPosts(query: .init(next: "", category: "curations")),
            of: PostListOutputType.self
         ) { result in
            switch result {
            case let .success(output):
               var newOutput = output
               let userId = UserDefaultsProvider.shared.getStringValue(.userId)
               newOutput.data = output.data.filter({ $0.creator.userId == userId })
               single(.success(.success(newOutput.toGetPostListVO)))
            case let .failure(error):
               single(.success(.failure(error)))
            }
         }
         return Disposables.create()
      }
   }
   public func getCurationPosts(query: GetCurationPostsInputVO) -> Single<Result<GetCurationPostListVO, NetworkErrors>> {
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
         let input: PostInputType = .init(category: "curations",
                                          title: input.curationName,
                                          content: input.superCateogry,
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

public struct MockPostRepository: MockPostRepositoryType, DefaultRepositoryType {
   public init() {}
   
   public func uploadImages(input: UploadFilesInputVO) async -> Result<UploadFilesOutputVO, CommonError> {
      let input: UploadFileInputType = .init(files: input.files)
      let result = await request(MockPostRouter.uploadFiles(input: input),
                                     of: PostsFileOutputType.self)
      
      switch result {
      case let .success(output):
         return .success(output.toVO)
      case let .failure(error):
         return .failure(error.mapToCommonError())
      }
   }
   
   public func uploadPost(input: UploadPostInputVO) async -> Result<UploadPostOutputVO, CommonError> {
      let input: PostInputType = .init(
         category: input.category.rawValue,
         title: input.title,
         content: input.content,
         content1: input.address,
         content2: String(input.rate),
         content3: input.hashTag,
         files: input.files,
         logitude: input.longitude,
         latitude: input.latitude
      )
      let result = await request(MockPostRouter.uploadPost(input: input), of: PostUploadOutputType.self)
      
      switch result {
      case let .success(output): return .success(output.toVO)
      case let .failure(error): return .failure(error.mapToCommonError())
      }
   }
   
   public func getPost(postId: String) async -> Result<GetPostVO, CommonError> {
      let result = await request(MockPostRouter.getPost(postId: postId), of: PostOutputType.self)
      switch result {
      case let .success(output): return .success(output.toGetPostVO)
      case let .failure(error): return .failure(error.mapToCommonError())
      }
   }
   
   public func getPosts(query: GetPostQueryVO) async -> Result<GetPostListVO, CommonError> {
      let query: GetPostQueryType = .init(next: query.next, category: query.category)
      let result = await request(MockPostRouter.getPosts(query: query), of: PostListOutputType.self)
      
      switch result {
      case .success(let success):
         return .success(success.toGetPostListVO)
      case .failure(let failure):
         return .failure(failure.mapToCommonError())
      }
   }
   
   public func getPostsByHashtag(query: GetPostByHashtagVO) async -> Result<GetPostListVO, CommonError> {
      let query: SearchQueryType = .init(next: query.next, category: query.category, hashTag: query.hashtag.mapToSnakecase())
      let result = await request(MockPostRouter.getPostsByHashtag(query: query), of: PostListOutputType.self)
      
      switch result {
      case .success(let success):
         return .success(success.toGetPostListVO)
      case .failure(let failure):
         return .failure(failure.mapToCommonError())
      }
   }
   
   public func getPostsByLocation(query: GEOSearchQueryVO) async -> Result<GetPostListVO, CommonError> {
      let query: SearchGEOQueryType = .init(
         category: query.category,
         longitude: query.longitude,
         latitude: query.latitude,
         maxDistance: query.maxDistance
      )
      let result = await request(MockPostRouter.getPostsByLocation(query: query), of: LocationSearchListOutput.self)
      
      switch result {
      case .success(let success):
         return .success(success.toVO)
      case .failure(let failure):
         return .failure(failure.mapToCommonError())
      }
   }
}
