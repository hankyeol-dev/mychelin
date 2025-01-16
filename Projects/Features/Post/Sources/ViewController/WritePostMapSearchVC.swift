// hankyeol-dev. Post

import UIKit
import Domain
import CommonUI
import ReactorKit
import RxCocoa
import Then
import SnapKit

public final class WritePostMapSearchVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
   }
   private let searchField: SearchField = .init()
   private let searchButton: RoundedButton = .init("장소 검색",
                                                   backgroundColor: .black,
                                                   baseColor: .white)
   private let locationAddButton: RoundedButton = .init("장소 등록",
                                                        backgroundColor: .grayLg,
                                                        baseColor: .grayXs)
   private let searchTableView: UITableView = .init().then {
      $0.register(cellType: LocationSearchCell.self)
      $0.rowHeight = 80.0
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setNavigationItems()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.reactor = WritePostMapSearchReactor()
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(searchField, searchButton, locationAddButton, searchTableView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      searchField.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(50.0)
      }
      searchButton.snp.makeConstraints { make in
         make.top.equalTo(searchField.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(50.0)
      }
      locationAddButton.snp.makeConstraints { make in
         make.top.equalTo(searchButton.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(50.0)
      }
      searchTableView.snp.makeConstraints { make in
         make.top.equalTo(locationAddButton.snp.bottom).offset(20.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalTo(view.safeAreaLayoutGuide)
      }
   }
   
   private func setNavigationItems() {
      title = "장소 검색"
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
   }
}

extension WritePostMapSearchVC: View {
   public func bind(reactor: WritePostMapSearchReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WritePostMapSearchReactor) {
      searchField.textField.rx.text
         .orEmpty
         .distinctUntilChanged()
         .bind(with: self) { vc, text in
            if !text.isEmpty {
               vc.searchButton.isEnabled = true
               vc.locationAddButton.isEnabled = false
            } else {
               vc.searchButton.isEnabled = false
               vc.locationAddButton.isEnabled = true
               vc.reactor?.action.onNext(.empty)
            }
         }.disposed(by: disposeBag)
      
      searchField.deleteButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.searchField.textField.text = ""
            vc.searchButton.isEnabled = false
            vc.locationAddButton.isEnabled = true
            vc.reactor?.action.onNext(.empty)
         }.disposed(by: disposeBag)

      searchButton.rx.tap
         .map({ [weak self] in
            self?.searchField.textField.resignFirstResponder()
            return Reactor.Action.query(self?.searchField.textField.text ?? "")
         })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
         
      locationAddButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.searchField.textField.resignFirstResponder()
            vc.pushToVC(WritePostMapVC())
         }.disposed(by: disposeBag)
      
      searchTableView.rx.modelSelected(NaverSearchVO.self)
         .bind(with: self) { vc, model in
            vc.searchField.textField.resignFirstResponder()
            print(model)
         }.disposed(by: disposeBag)
   }
   
   private func bindStates(_ reactor: WritePostMapSearchReactor) {
      reactor.state.map(\.searched)
         .bind(to: searchTableView.rx.items(
            cellIdentifier: LocationSearchCell.reuseIdentifier,
            cellType: LocationSearchCell.self)) { _, item, cell in
               cell.setCell(item)
            }.disposed(by: disposeBag)
   }
}
