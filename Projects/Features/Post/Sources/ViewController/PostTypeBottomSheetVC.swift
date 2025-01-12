// hankyeol-dev. Post

import UIKit
import CommonUI
import SnapKit
import Then
import RxSwift
import RxCocoa

public final class PostTypeBottomSheetVC: BaseVC {
   public var didDisappearHandler: ((SelectedType) -> Void)?
   public enum SelectedType {
      case curation, post
   }

   private let disposeBag: DisposeBag = .init()
   private var selectedButton: BehaviorSubject<SelectedType?> = .init(value: nil)
   
   private let sheetTitleLabel: BaseLabel = .init(
      .init(text: "작성할 항목을 선택해주세요.", style: .largeTitle)
   )
   private let buttonStack: UIStackView = .init().then {
      $0.axis = .vertical
      $0.spacing = 10.0
      $0.distribution = .fillEqually
   }
   private let curationButton: RoundedButton = .init("큐레이션 항목 생성",
                                                     backgroundColor: .grayXs,
                                                     baseColor: .black)
   private let postButton: RoundedButton = .init("글 작성",
                                                 backgroundColor: .grayXs,
                                                 baseColor: .black)
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      bind()
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(sheetTitleLabel, buttonStack)
      buttonStack.addStackSubviews(curationButton, postButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let inset = 20.0
      let guide = view.safeAreaLayoutGuide
      sheetTitleLabel.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(guide).inset(inset)
      }
      buttonStack.snp.makeConstraints { make in
         make.top.equalTo(sheetTitleLabel.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.bottom.equalTo(guide).inset(inset)
      }
   }
   
   private func bind() {
      curationButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.selectedButton.onNext(.curation)
         }.disposed(by: disposeBag)
      postButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.selectedButton.onNext(.post)
         }.disposed(by: disposeBag)
      selectedButton
         .bind(with: self) { vc, type in
            if let type {
               vc.bindButtonConfiguration(type == .curation ? vc.curationButton : vc.postButton)
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  vc.dismiss(animated:  true)
               }
            }
         }.disposed(by: disposeBag)
   }
   
   private func bindButtonConfiguration(_ button: RoundedButton) {
      button.configuration?.baseBackgroundColor = .black
      button.configuration?.baseForegroundColor = .white
   }
}
