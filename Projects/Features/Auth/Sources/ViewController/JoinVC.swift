// hankyeol-dev. Auth

import Foundation

import CommonUI
import Domain

import SnapKit
import ReactorKit

public final class JoinVC: BaseVC {
   private let emailField: RoundedTextField = .init(placeholder: "이메일을 입력해주세요.",
                                                    keyboardType: .emailAddress,
                                                    selectedTitle: "Email")
   private let passwordField: RoundedTextField = .init(placeholder: "비밀번호를 입력해주세요.",
                                                       keyboardType: .default,
                                                       selectedTitle: "Password",
                                                       isSecure: true)
   private let nicknameField: RoundedTextField = .init(placeholder: "닉네임을 입력해주세요.",
                                                       keyboardType: .default,
                                                       selectedTitle: "Nick")
   private let joinButton: RoundedButton = .init("회원가입")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      self.reactor = JoinReactor()
      title = "계정 생성"
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(emailField, passwordField, nicknameField, joinButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      emailField.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(5.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(50.0)
      }
      passwordField.snp.makeConstraints { make in
         make.top.equalTo(emailField.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(50.0)
      }
      nicknameField.snp.makeConstraints { make in
         make.top.equalTo(passwordField.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(50.0)
      }
      joinButton.snp.makeConstraints { make in
         make.top.equalTo(nicknameField.snp.bottom).offset(15.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(40.0)
      }
   }
}

extension JoinVC: View {
   public func bind(reactor: JoinReactor) {
      bindActions(reactor: reactor)
      bindStates(reactor: reactor)
   }
   
   private func bindActions(reactor: JoinReactor) {
      emailField.textField.rx.text
         .orEmpty
         .distinctUntilChanged()
         .map({ Reactor.Action.textEmail($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      passwordField.textField.rx.text
         .orEmpty
         .distinctUntilChanged()
         .map({ Reactor.Action.textPassword($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      nicknameField.textField.rx.text
         .orEmpty
         .distinctUntilChanged()
         .map({ Reactor.Action.textNick($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      joinButton.rx.tap
         .map({ .tapJoinButton })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(reactor: JoinReactor) {
      reactor.state.map({ $0.isLogined })
         .distinctUntilChanged()
         .debug("isLogined")
         .bind(with: self) { vc, result in
            print(result)
         }.disposed(by: disposeBag)
   }
}
