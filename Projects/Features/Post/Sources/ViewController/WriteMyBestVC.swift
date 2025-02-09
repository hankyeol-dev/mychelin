// hankyeol-dev. Post

import UIKit
import PhotosUI
import CommonUI
import Domain
import SnapKit
import ReactorKit
import RxGesture

public final class WriteMyBestVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let scrollView: BaseScrollView = .init()
   private let postButton: UIButton = .init().then {
      $0.setTitle("나의 베스트 스팟 등록", for: .normal)
      $0.setTitleColor(.grayXs, for: .normal)
      $0.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
      $0.backgroundColor = .grayLg
      $0.isEnabled = false
   }
   
   private let userNameLabel: BaseLabel = .init(.init(style: .xLargeTitle))
   private let categoryLabel: BaseLabel = .init(.init(text: "스팟 중에서", style: .xLargeTitle))
   private let selectLabel: BaseLabel = .init(.init(text: "베스트 오브 베스트는?", style: .xLargeTitle))
   private let categoryButton: FoodCategoryButton = .init(.boong)
   
   private let spotNameField: LinedField = .init("스팟 이름", placeholder: "스팟 이름을 작성해주세요.")
   private let searchedSpotTable: UITableView = .init().then {
      $0.register(cellType: LocationSearchCell.self)
      $0.rowHeight = 80.0
      $0.showsVerticalScrollIndicator = false
      $0.separatorStyle = .none
   }
   private let spotAddressField: LinedField = .init("스팟 주소", placeholder: "스팟 주소를 작성해주세요.")
   private let spotRating: StarRating = .init("스팟 추천 점수")
   private let spotPost: LabeledTextView = .init("스팟 경험", placeholder: "스팟에 대한 경험을 남겨주세요.")
   private let spotPhotoPicker: LabeledPhotoBox = .init("스팟 사진 (선택, 최대 3장)")
   private lazy var spotPhotoCollection: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = .init(width: 80.0, height: 60.0)
      layout.minimumLineSpacing = 10.0
      let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
      view.register(cellType: SpotPhotoCell.self)
      view.isScrollEnabled = false
      return view
   }()
      
   public override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(postButton, scrollView)
      scrollView.contentView.addSubviews(
         userNameLabel, categoryButton, categoryLabel, selectLabel,
         spotNameField, searchedSpotTable, spotAddressField, spotRating, spotPost,
         spotPhotoPicker, spotPhotoCollection
      )
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = scrollView.contentView.safeAreaLayoutGuide
      let inset = 20.0
      
      postButton.snp.makeConstraints { make in
         make.height.equalTo(100.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalTo(view)
      }
      scrollView.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalTo(postButton.snp.top)
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
         make.height.equalTo(65.0)
      }
      searchedSpotTable.snp.makeConstraints { make in
         make.top.equalTo(spotNameField.snp.bottom)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      spotAddressField.snp.makeConstraints { make in
         make.top.equalTo(searchedSpotTable.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(65.0)
      }
      spotRating.snp.makeConstraints { make in
         make.top.equalTo(spotAddressField.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      spotPost.snp.makeConstraints { make in
         make.top.equalTo(spotRating.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(130.0)
      }
      spotPhotoPicker.snp.makeConstraints { make in
         make.top.equalTo(spotPost.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      spotPhotoCollection.snp.makeConstraints { make in
         make.top.equalTo(spotPhotoPicker.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      
      scrollView.addBottomView(spotPhotoCollection)
   }
}

extension WriteMyBestVC: PHPickerViewControllerDelegate {
   public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      reactor?.action.onNext(.setPhotos(results.map(\.itemProvider)))
   }
   
   private func presentPicker() {
      let current = reactor?.currentState.spotPhotos.count ?? 0
      if current != 3 {
         var config = PHPickerConfiguration()
         config.filter = .images
         config.selectionLimit = 3 - current
         config.selection = .ordered
         
         let imagePicker = PHPickerViewController(configuration: config)
         imagePicker.delegate = self
         
         self.present(imagePicker, animated: true)
      }
   }
}

extension WriteMyBestVC: View {
   public func bind(reactor: WriteMyBestReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WriteMyBestReactor) {
      reactor.action.onNext(.didLoad)
      
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
         .skip(2)
         .distinctUntilChanged()
         .debounce(.seconds(1), scheduler: MainScheduler.instance)
         .map({ Reactor.Action.searchSpotLocation(query: $0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      searchedSpotTable.rx.modelSelected(NaverSearchVO.self)
         .map({ Reactor.Action.selectSpotLocation($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      spotRating.ratingView.didTouchCosmos = { rating in
         reactor.action.onNext(.setRate(rating))
      }
      
      spotPhotoPicker.photoButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.presentPicker()
         }.disposed(by: disposeBag)
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
               vc.spotNameField.resignFirstResponder()
               vc.hideSearchedTable()
            }
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.spotPhotos)
         .distinctUntilChanged()
         .bind(with: self) { vc, items in
            vc.showPhotoCollection(items)
         }.disposed(by: disposeBag)
   }
   
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
   
   private func showPhotoCollection(_ items: [NSItemProvider]) {
      spotPhotoCollection.delegate = nil
      spotPhotoCollection.dataSource = nil
      
      UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseInOut) { [weak self] in
         if !items.isEmpty {
            self?.spotPhotoCollection.snp.remakeConstraints { make in
               make.height.equalTo(80.0)
            }
         } else {
            self?.spotPhotoCollection.snp.remakeConstraints { make in
               make.height.equalTo(0.0)
            }
         }
         self?.view.setNeedsLayout()
      }
      
      if !items.isEmpty {
         Observable.just(items)
            .bind(to: spotPhotoCollection.rx.items(
               cellIdentifier: SpotPhotoCell.reuseIdentifier,
               cellType: SpotPhotoCell.self)) { [weak self] _, item, cell in
                  guard let self else { return }
                  cell.setCell(item)
                  cell.closeButton.rx.tap
                     .bind(with: self) { vc, _ in
                        vc.reactor?.action.onNext(.removeFromPhotos(item))
                     }
                     .disposed(by: cell.disposeBag)
               }.disposed(by: disposeBag)
      }
   }
}
