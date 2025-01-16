// hankyeol-dev. Post

import UIKit
import CoreLocation

import CommonUI

import RxSwift
import RxCocoa
import ReactorKit
import RxGesture
import Then
import SnapKit
import DropDown
import Cosmos

public final class WritePostVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private var location: CLLocationCoordinate2D?
   private var address: String = ""
   
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
   }
   private let backButton: UIButton = .init().then {
      let image: UIImage = .leftOutline.withRenderingMode(.alwaysTemplate)
      $0.setImage(image, for: .normal)
      $0.tintColor = .black
   }
   private let scrollView: UIScrollView = .init().then {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
   }
   private let back: UIView = .init()
   private let locationField: RoundedField = .init("장소 위치").then {
      $0.fieldDisabled()
   }
   
   private let locationNameField: RoundedField = .init("장소 이름", placeholder: "장소에 대한 대략적인 이름")
   private let curationTitle: BaseLabel = .init(
      .init(text: "큐레이션 지정 (선택)", style: .subtitle))
   private let curationDrop: RoundedDropdown = .init("연결할 큐레이션을 선택해주세요.")
   private let dropDown: DropDown = .init().then {
      $0.backgroundColor = .grayXs
      $0.textColor = .grayLg
      $0.selectedTextColor = .white
      $0.selectionBackgroundColor = .grayMd
      $0.dismissMode = .automatic
      $0.layer.cornerRadius = 10.0
   }
   private let starRatingTitle: BaseLabel = .init(
      .init(text: "장소는 어떤가요? (선택)", style: .subtitle))
   private let starRatingBox: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.cornerRadius = 10.0
   }
   private let starRating: CosmosView = .init().then {
      $0.settings.starSize = 30.0
      $0.settings.starMargin = 20.0
      $0.settings.totalStars = 5
      $0.settings.fillMode = .half
      $0.settings.minTouchRating = 0.0
      $0.rating = 0
      
      $0.settings.filledImage = .starFill
      $0.settings.emptyImage = .starUnFill
      $0.settings.emptyColor = .grayMd
      $0.settings.filledColor = .greenMd
   }
   
   private let bottomView: UIView = .init().then { $0.backgroundColor = .clear }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setNavigationItems()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.reactor = WritePostReactor()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(scrollView)
      scrollView.addSubview(back)
      back.addSubviews(
         locationField, locationNameField,
         curationTitle, curationDrop,
         starRatingTitle, starRatingBox,
         bottomView
      )
      starRatingBox.addSubview(starRating)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let inset = 20.0
      let verticalSpace = 10.0
      let guide = back.safeAreaLayoutGuide
      scrollView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      back.snp.makeConstraints { make in
         make.width.equalTo(scrollView.snp.width)
         make.verticalEdges.equalTo(scrollView)
      }
      locationField.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      locationNameField.snp.makeConstraints { make in
         make.top.equalTo(locationField.snp.bottom).offset(verticalSpace)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      curationTitle.snp.makeConstraints { make in
         make.top.equalTo(locationNameField.snp.bottom).offset(verticalSpace)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      curationDrop.snp.makeConstraints { make in
         make.top.equalTo(curationTitle.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(40.0)
      }
      starRatingTitle.snp.makeConstraints { make in
         make.top.equalTo(curationDrop.snp.bottom).offset(20.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      starRatingBox.snp.makeConstraints { make in
         make.top.equalTo(starRatingTitle.snp.bottom).offset(verticalSpace)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(60.0)
      }
      starRating.snp.makeConstraints { make in
         make.center.equalTo(starRatingBox.snp.center)
      }
      bottomView.snp.makeConstraints { make in
         make.top.equalTo(starRatingBox.snp.bottom)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(inset)
         make.bottom.equalTo(guide)
      }
   }
   
   private func setNavigationItems() {
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
      navigationItem.setLeftBarButton(.init(customView: backButton), animated: true)
   }
   
   public func setLocation(_ location: CLLocationCoordinate2D, _ address: String) {
      self.location = location
      self.address = address
      locationField.textField.text = address
   }
}

extension WritePostVC: View {
   public func bind(reactor: WritePostReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WritePostReactor) {
      reactor.action.onNext(.didLoad)

      xButton.rx.tap.bind(with: self) { vc, _ in
         vc.dismiss(animated: true)
      }.disposed(by: disposeBag)
      
      backButton.rx.tap.bind(with: self) { vc, _ in
         vc.navigationController?.popViewController(animated: true)
      }.disposed(by: disposeBag)

      curationDrop.rx.tapGesture()
         .when(.recognized)
         .bind(with: self) { vc, _ in
            vc.locationNameField.resignFirstResponder()
            vc.dropDown.show()
         }.disposed(by: disposeBag)
      
      starRating.didTouchCosmos = { rating in }
   }
   
   private func bindStates(_ reactor: WritePostReactor) {
      reactor.state.map(\.curations)
         .filter({ !$0.isEmpty })
         .bind(with: self) { vc, curations in
            vc.dropDown.dataSource = curations
            vc.dropDown.anchorView = vc.curationDrop
            vc.dropDown.bottomOffset = CGPoint(x: 0.0, y: 45.0)
            vc.dropDown.selectionAction = { [weak vc] _, curation in
               vc?.reactor?.action.onNext(.selectCuration(curation))
            }
         }
         .disposed(by: disposeBag)
      reactor.state.map(\.selectedCuration)
         .filter({ !$0.isEmpty })
         .bind(with: self) { vc, curation in
            vc.curationDrop.setLabel(curation)
         }.disposed(by: disposeBag)
   }
}
