// hankyeol-dev. Profile

import Foundation
import Domain
import ReactorKit
import RxDataSources

public final class MeProfileReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let userUsecase: MockUserUsecaseType
   
   public var initialState: State = .init()
   
   public struct State {
      var profileObject: MeProfileVO?
      var errorMessage: String?
      var infoSection = MeProfileSection.Model(
         model: .info,
         items: []
      )
      var divider = MeProfileSection.Model(
         model: .divider,
         items: []
      )
      var postSection = MeProfileSection.Model(
         model: .post,
         items: []
      )
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case fetchUserInfo(Result<MeProfileVO, CommonError>)
      case fetchUserPosts([ProfileMyPostCell.CellData])
      case setDivider
   }
   
   public init(_ usecase: MockUserUsecaseType) {
      self.userUsecase = usecase
   }
   
   deinit { print(#function) }
}

extension MeProfileReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         let profile = userUsecase.getMe()
         let posts = FoodCategories.allCases.map({
            let result = userUsecase.getMyPosts($0.rawValue)
            switch result {
            case let .success(list):
               return ProfileMyPostCell.CellData(category: $0, count: list.count)
            case .failure:
               return ProfileMyPostCell.CellData(category: $0, count: 0)
            }
         })
         return .concat(.just(.fetchUserInfo(profile)), .just(.fetchUserPosts(posts)), .just(.setDivider))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .fetchUserInfo(result):
         switch result {
         case let .success(vo):
            newState.infoSection = .init(model: .info, items: [.info(vo)])
         case let .failure(error):
            newState.errorMessage = error.toMessage
         }
      case let .fetchUserPosts(results):
         newState.postSection = .init(model: .post, items: .init(
            arrayLiteral: .post(results.sorted(by: { data, data2 in
               data.count > data2.count
            }))))
      case .setDivider:
         newState.divider = .init(model: .divider, items: [.divider])
      }
      return newState
   }
}
