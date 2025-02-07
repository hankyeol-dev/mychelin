// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import SnapKit
import ReactorKit
import RxGesture

public final class WriteMyBestVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let scrollView: BaseScrollView = .init()
   
   private let userNameLabel: BaseLabel = .init(.init(style: .xLargeTitle))
   private let categoryLabel: BaseLabel = .init(.init(text: "스팟 중에서", style: .xLargeTitle))
   private let selectLabel: BaseLabel = .init(.init(text: "베스트 오브 베스트는?", style: .xLargeTitle))
   private let categoryButton: FoodCategoryButton = .init(.boong)
   
   private let spotNameField: RoundedField = .init("스팟 이름", placeholder: "스팟 이름을 작성해주세요.")
   private let searchedSpotTable: UITableView = .init().then {
      $0.register(cellType: LocationSearchCell.self)
      $0.rowHeight = 80.0
      $0.showsVerticalScrollIndicator = false
      $0.separatorStyle = .none
   }
   private let spotAddressField: RoundedField = .init("스팟 주소", placeholder: "스팟 주소를 작성해주세요.")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      reactor = WriteMyBestReactor()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(scrollView)
      scrollView.contentView.addSubviews(
         userNameLabel, categoryButton, categoryLabel, selectLabel,
         spotNameField, searchedSpotTable, spotAddressField
      )
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = scrollView.contentView.safeAreaLayoutGuide
      let inset = 20.0
      scrollView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      
      // MARK: Top Category Selection Part
      userNameLabel.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(guide).inset(inset)
      }
      categoryButton.snp.makeConstraints { make in
         make.width.equalTo(210.0)
         make.height.equalTo(56.0)
         make.top.equalTo(userNameLabel.snp.bottom).offset(inset)
         make.leading.equalTo(guide).inset(inset)
      }
      categoryLabel.snp.makeConstraints { make in
         make.top.equalTo(userNameLabel.snp.bottom).offset(inset)
         make.leading.equalTo(categoryButton.snp.trailing).offset(inset - 5.0)
         make.height.equalTo(56.0)
      }
      selectLabel.snp.makeConstraints { make in
         make.top.equalTo(categoryButton.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      
      // MARK: Body Post Part
      spotNameField.snp.makeConstraints { make in
         make.top.equalTo(selectLabel.snp.bottom).offset(inset * 2)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      searchedSpotTable.snp.makeConstraints { make in
         make.top.equalTo(spotNameField.snp.bottom)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      spotAddressField.snp.makeConstraints { make in
         make.top.equalTo(searchedSpotTable.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      
      scrollView.addBottomView(spotAddressField)
   }
}

extension WriteMyBestVC: View {
   public func bind(reactor: WriteMyBestReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WriteMyBestReactor) {
      reactor.action.onNext(.didLoad)
      
//      scrollView.contentView.rx.tapGesture()
//         .bind(with: self) { vc, _ in
//            vc.spotNameField.textField.
//         }.disposed(by: disposeBag)

      categoryButton.rx.tap
         .bind(with: self) { vc, _ in
            let target = FoodCategoryVC()
            
            if let sheet = target.sheetPresentationController {
               sheet.detents = [.medium(), .large()]
               sheet.prefersGrabberVisible = true
            }
            target.bind(reactor.currentState.selectedFoodCategory)
            target.dismissHandler = { category in
               reactor.action.onNext(.updateFoodCategory(category))
            }
            vc.present(target, animated: true)
         }.disposed(by: disposeBag)
      
      spotNameField.textField.rx.text
         .orEmpty
         .skip(1)
         .distinctUntilChanged()
         .debounce(.seconds(1), scheduler: MainScheduler.instance)
         .map({ Reactor.Action.searchSpotLocation(query: $0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      searchedSpotTable.rx.modelSelected(NaverSearchVO.self)
         .map({ Reactor.Action.selectSpotLocation($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(_ reactor: WriteMyBestReactor) {
      userNameLabel.setText(reactor.currentState.userNickname + " 님의")
      categoryButton.updateCategory(reactor.initialState.selectedFoodCategory)
      
      reactor.state.map(\.selectedFoodCategory)
         .bind(with: self) { vc, category in
            vc.categoryButton.updateCategory(category)
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.searchSpotLocation)
         .bind(with: self) { vc, searched in
            if searched.isEmpty {
               vc.hideSearchedTable()
            } else {
               vc.showSearchedTable(searched)
            }
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.selectedSpotLocation)
         .bind(with: self) { vc, location in
            if let location {
               vc.spotAddressField.setTextField(location.roadAddress)
               vc.hideSearchedTable()
            }
         }.disposed(by: disposeBag)
   }
   // 오월의김밥
   private func hideSearchedTable() {
      UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseInOut) { [weak self] in
         self?.searchedSpotTable.snp.remakeConstraints { make in
            make.height.equalTo(0.0)
         }
         self?.view.setNeedsLayout()
      }
   }
   
   private func showSearchedTable(_ searched: [NaverSearchVO]) {
      searchedSpotTable.dataSource = nil
      searchedSpotTable.delegate = nil
      UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseInOut) { [weak self] in
         self?.searchedSpotTable.snp.remakeConstraints { make in
            make.height.equalTo(180.0)
         }
         self?.view.setNeedsLayout()
      }
      
      Observable.just(searched)
         .bind(to: searchedSpotTable.rx.items(
            cellIdentifier: LocationSearchCell.reuseIdentifier,
            cellType: LocationSearchCell.self)) { _, item, cell in
               cell.setCell(item)
            }
            .disposed(by: disposeBag)
   }
}
