// hankyeol-dev. Post

import UIKit
import CommonUI
import Common
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
   private let curationColorTitle: BaseLabel = .init(
      .init(text: "큐레이션 색상", style: .subtitle))
   private let curationColorBox: UIView = .init().then {
      $0.backgroundColor = .graySm
      $0.layer.cornerRadius = 10.0
   }
   private lazy var curationColorCollection: UICollectionView = .init(
      frame: .zero,
      collectionViewLayout: setCollectionLayout()
   ).then {
      $0.register(cellType: ColorCell.self)
      $0.showsVerticalScrollIndicator = false
      $0.isScrollEnabled = false
      $0.backgroundColor = .clear
   }
   private let curationMakePublicTitle: BaseLabel = .init(
      .init(text: "큐레이션 공개 여부", style: .subtitle))
   private let curationMakePublicBox: UIView = .init().then {
      $0.backgroundColor = .graySm
      $0.layer.cornerRadius = 10.0
   }
   private let curationMakePublicLabel: BaseLabel = .init(
      .init(text: "큐레이션을 공개합니다.", style: .base))
   private let curationMakePublicSwitch: UISwitch = .init().then {
      $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
      $0.onTintColor = .greenMd
   }
   private let createButton: UIButton = .init().then {
      $0.setTitle("큐레이션 생성", for: .normal)
      $0.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setDismissButton()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.reactor = WritePostCurationReactor()
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(
         pageTitle, firstCategoryTitle, firstCategoryDrop, curationTitleField,
         curationColorTitle, curationColorBox, createButton, curationMakePublicTitle, curationMakePublicBox
      )
      curationColorBox.addSubview(curationColorCollection)
      curationMakePublicBox.addSubviews(curationMakePublicLabel, curationMakePublicSwitch)
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
      curationColorTitle.snp.makeConstraints { make in
         make.top.equalTo(curationTitleField.snp.bottom).offset(inset)
         make.leading.equalToSuperview().inset(inset)
      }
      curationColorBox.snp.makeConstraints { make in
         make.top.equalTo(curationColorTitle.snp.bottom).offset(10.0)
         make.horizontalEdges.equalToSuperview().inset(inset)
         make.height.equalTo(140.0)
      }
      curationColorCollection.snp.makeConstraints { make in
         make.edges.equalTo(curationColorBox.safeAreaLayoutGuide).inset(20.0)
      }
      curationMakePublicTitle.snp.makeConstraints { make in
         make.top.equalTo(curationColorBox.snp.bottom).offset(inset)
         make.horizontalEdges.equalToSuperview().inset(inset)
      }
      curationMakePublicBox.snp.makeConstraints { make in
         make.top.equalTo(curationMakePublicTitle.snp.bottom).offset(10.0)
         make.horizontalEdges.equalToSuperview().inset(inset)
         make.height.equalTo(40.0)
      }
      curationMakePublicLabel.snp.makeConstraints { make in
         make.centerY.equalTo(curationMakePublicBox.snp.centerY)
         make.leading.equalTo(curationMakePublicBox.safeAreaLayoutGuide).inset(inset)
         make.trailing.equalTo(curationMakePublicSwitch.snp.trailing).offset(-inset)
      }
      curationMakePublicSwitch.snp.makeConstraints { make in
         make.centerY.equalTo(curationMakePublicBox.snp.centerY)
         make.trailing.equalTo(curationMakePublicBox.safeAreaLayoutGuide).inset(inset)
      }
      createButton.snp.makeConstraints { make in
         make.horizontalEdges.bottom.equalToSuperview()
         make.height.equalTo(100.0)
      }
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
      
      curationColorCollection.rx
         .itemSelected
         .distinctUntilChanged()
         .map(\.row)
         .map({ Reactor.Action.selectCurationColor($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      curationMakePublicSwitch.rx.isOn
         .map({ Reactor.Action.setCurationMakePublic($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)

      createButton.rx.tap
         .map({ Reactor.Action.tapCreateButton })
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
      
      reactor.state.map(\.curationColors)
         .bind(to: curationColorCollection.rx.items(
            cellIdentifier: ColorCell.reuseIdentifier,
            cellType: ColorCell.self)
         ) { _, color, cell in
            cell.setColor(color.0.toColor, isSelected: color.1)
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.canCreate)
         .distinctUntilChanged()
         .bind(with: self) { vc, canCreate in
            if canCreate {
               vc.createButton.backgroundColor = .greenMd
               vc.createButton.setTitleColor(.white, for: .normal)
               vc.createButton.isEnabled = true
            } else {
               vc.createButton.backgroundColor = .graySm
               vc.createButton.setTitleColor(.grayMd, for: .normal)
               vc.createButton.isEnabled = false
            }
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.createdCurationId)
         .distinctUntilChanged()
         .bind(with: self) { vc, postId in
            if let postId {
               let pushedVC: CurationDetailVC = .init()
               pushedVC.setCurationId(postId)
               pushedVC.didDisappearHandler = { vc.dismiss(animated: true) }
               vc.pushToVC(pushedVC)
            }
         }.disposed(by: disposeBag)
   }
}

extension WritePostCurationVC {
   private func setCollectionLayout() -> UICollectionViewFlowLayout {
      let flow = UICollectionViewFlowLayout()
      flow.scrollDirection = .vertical
      flow.itemSize = .init(width: 40.0, height: 40.0)
      flow.minimumLineSpacing = 20.0
      return flow
   }
}
