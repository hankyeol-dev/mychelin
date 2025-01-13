// hankyeol-dev. Post

import UIKit
import CommonUI
import SnapKit
import RxCocoa
import RxGesture
import ReactorKit
import DropDown
import Then

public final class WritePostCurationVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
      $0.tintColor = .grayLg
   }
   private let pageTitle: BaseLabel = .init(
      .init(text: "나만의 장소 큐레이션을 만들어보세요.",
            style: .largeTitle)
   ).then {
      $0.numberOfLines = 2
      $0.textAlignment = .left
   }
   private let firstCategoryTitle: BaseLabel = .init(
      .init(text: "큐레이션 카테고리", style: .subtitle))
   private let firstCategoryDrop: RoundedDropdown = .init("큐레이션 카테고리를 선택해주세요.")
   private let dropDown: DropDown = .init().then {
      $0.backgroundColor = .grayXs
      $0.textColor = .grayLg
      $0.selectedTextColor = .white
      $0.selectionBackgroundColor = .grayMd
      $0.dismissMode = .automatic
      $0.layer.cornerRadius = 10.0
   }
   private let curationTitleField: RoundedField = .init("큐레이션 이름",
                                                        placeholder: "큐레이션 이름을 입력해주세요.")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setDismissButton()
      self.reactor = WritePostCurationReactor()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(pageTitle, firstCategoryTitle, firstCategoryDrop, curationTitleField)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = view.safeAreaLayoutGuide
      let inset = 20.0
      pageTitle.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(guide).inset(inset)
      }
      firstCategoryTitle.snp.makeConstraints { make in
         make.top.equalTo(pageTitle.snp.bottom).offset(inset)
         make.leading.equalToSuperview().inset(inset)
      }
      firstCategoryDrop.snp.makeConstraints { make in
         make.top.equalTo(firstCategoryTitle.snp.bottom).offset(10.0)
         make.horizontalEdges.equalToSuperview().inset(inset)
         make.height.equalTo(40.0)
      }
      curationTitleField.snp.makeConstraints { make in
         make.top.equalTo(firstCategoryDrop.snp.bottom).offset(inset)
         make.horizontalEdges.equalToSuperview().inset(inset)
         make.height.equalTo(70.0)
      }
   }
   
   public override func setViews() {
      super.setViews()
   }
   
   private func setDismissButton() {
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
   }
}

extension WritePostCurationVC: View {
   public func bind(reactor: WritePostCurationReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WritePostCurationReactor) {
      view.rx.tapGesture()
         .when(.recognized)
         .bind(with: self) { vc, _ in
            vc.view.endEditing(true)
         }.disposed(by: disposeBag)
      
      xButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.dismiss(animated: true)
         }.disposed(by: disposeBag)
      
      firstCategoryDrop.rx.tapGesture()
         .when(.recognized)
         .bind(with: self) { vc, _ in
            vc.dropDown.show()
         }.disposed(by: disposeBag)
      
      curationTitleField.textField.rx.text
         .orEmpty
         .distinctUntilChanged()
         .map({ Reactor.Action.setCurationName($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(_ reactor: WritePostCurationReactor) {
      reactor.state.map(\.firstCategories)
         .bind(with: self) { vc, categories in
            vc.dropDown.dataSource = categories.map({ $0.toKorean })
            vc.dropDown.anchorView = vc.firstCategoryDrop
            vc.dropDown.bottomOffset = CGPoint(x: 0, y: 45.0)
            vc.dropDown.selectionAction = { [weak vc] (index, _) in
               vc?.reactor?.action.onNext(.selectFirstCategory(index))
            }
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.selectedFirstCategory)
         .distinctUntilChanged()
         .bind(with: self) { vc, category in
            if let category {
               vc.firstCategoryDrop.setLabel(category.toKorean)
            }
         }.disposed(by: disposeBag)
   }
}
