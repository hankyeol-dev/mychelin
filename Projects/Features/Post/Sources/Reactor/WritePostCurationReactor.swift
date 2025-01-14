// hankyeol-dev. Post

import Foundation
import Common
import Domain
import Data
import ReactorKit

public final class WritePostCurationReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let postUsecase: PostUsecaseType = PostUsecase(postRepository: PostRepository())
   
   public var initialState: State = .init()
   
   public struct State {
      let firstCategories: [FirstCategories] = FirstCategories.allCases.map({ $0 })
      var curationColors: [(CurationColors, Bool)] = CurationColors.allCases.map({ ($0, false) })
      
      var selectedFirstCategory: FirstCategories?
      var curationName: String = ""
      var curationMakePublic: Bool = false
      var canCreate: Bool = false
      var createdCurationId: String?
   }
   
   public enum Action {
      case selectFirstCategory(Int)
      case selectCurationColor(Int)
      case setCurationName(String)
      case setCurationMakePublic(Bool)
      case tapCreateButton
   }
   
   public enum Mutation {
      case setFirstCategory(Int)
      case setCurationColor(Int)
      case setCurationName(String)
      case setCurationMakePublic(Bool)
      case validateCanCreate
      case tapCreateButton(Result<CreateCurationOutputVO, NetworkErrors>)
   }
}

extension WritePostCurationReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .selectFirstCategory(index):
         return .concat([.just(.setFirstCategory(index)), .just(.validateCanCreate)])
      case let .setCurationName(name):
         return .concat([.just(.setCurationName(name)), .just(.validateCanCreate)])
      case let .selectCurationColor(index):
         return .concat([.just(.setCurationColor(index)), .just(.validateCanCreate)])
      case let .setCurationMakePublic(isOn):
         return .just(.setCurationMakePublic(isOn))
      case .tapCreateButton:
         if initialState.canCreate,
            !initialState.curationName.isEmpty,
            let category = initialState.selectedFirstCategory,
            let colorIndex = initialState.curationColors.filter({ $0.1 }).first?.0.rawValue
         {
            let input: CreateCurationInputVO = .init(
               firstCategory: category.toKorean,
               curationName: initialState.curationName.toSnakeCategory(),
               curationColorIndex: colorIndex,
               curationMakePublic: initialState.curationMakePublic ? 0 : 1
            )
            return postUsecase.createCuration(input: input)
               .asObservable()
               .map({ Mutation.tapCreateButton($0) })
         } else {
            return .empty()
         }
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newstate = state
      switch mutation {
      case let .setFirstCategory(index):
         newstate.selectedFirstCategory = state.firstCategories[index]
         initialState.selectedFirstCategory = state.firstCategories[index]
      case let .setCurationName(name):
         newstate.curationName = name
         initialState.curationName = name
      case let .setCurationColor(index):
         let newColors = newstate.curationColors.enumerated().map({ idx, el in
            var target = el
            if idx == index {
               target.1 = true
            } else {
               target.1 = false
            }
            return target
         })
         newstate.curationColors = newColors
         initialState.curationColors = newColors
      case let .setCurationMakePublic(isOn):
         newstate.curationMakePublic = isOn
         initialState.curationMakePublic = isOn
      case .validateCanCreate:
         if !state.curationName.isEmpty
               && state.selectedFirstCategory != nil
               && !state.curationColors.filter({ $0.1 }).isEmpty {
            newstate.canCreate = true
            initialState.canCreate = true
         } else {
            newstate.canCreate = false
            initialState.canCreate = false
         }
         
      case let .tapCreateButton(result):
         switch result {
         case let .success(vo):
            newstate.createdCurationId = vo.postId
            initialState.createdCurationId = vo.postId
         case let .failure(error):
            print(String(describing: self), error)
         }
      }
      return newstate
   }
}
