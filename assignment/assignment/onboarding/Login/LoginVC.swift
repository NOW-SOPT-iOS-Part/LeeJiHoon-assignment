//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, UITextFieldDelegate {
  
    var nickname: String?

    // MARK: - Properties
    private var viewModel: LoginViewModelType = LoginViewModel()
    private let disposeBag = DisposeBag()

    
    let loginLabel = UILabel().then {
        $0.text = "TVING ID 로그인"
        $0.textColor = UIColor(named: "gray84")
        $0.font = UIFont(name: "Pretendard-Medium", size: 24)
    }
    
    let idTextFieldView = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray4")
        $0.layer.cornerRadius = 3
        $0.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "gray2")])
    }
    
    let passwordTextFieldView = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray4")
        $0.layer.cornerRadius = 3
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "gray2")])
        $0.isSecureTextEntry = true
    }
    
    let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("로그인하기", for: .normal)
        $0.layer.cornerRadius = 3
        $0.isEnabled = false
    }
    
    let findId = UILabel().then {
        $0.text = "아이디 찾기"
        $0.textColor = UIColor(named: "gray2")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    let findPw = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.textColor = UIColor(named: "gray2")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    let noAccount = UILabel().then {
        $0.text = "아직계정이 없으신가요?"
        $0.textColor = UIColor(named: "gray3")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    let makeAccount = UIButton().then {
        let title = "닉네임 만들러 가기"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-SemiBold", size: 14)!,
            .foregroundColor: UIColor(named: "gray2")!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    
    let spaceView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray2")
    }
    
    
    let eyeButton = UIButton(type: .custom)
    let xCircleButton = UIButton(type: .custom)
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        idTextFieldView.delegate = self
        passwordTextFieldView.delegate = self
        
        addSubViews()
        setConstraints()
        bindViewModel()
        
        setupPasswordField()
        setupButtons()
        setupTextFieldTargets()
    }

    private func setupPasswordField() {
        // 패스워드 텍스트 필드 설정
        eyeButton.setImage(UIImage(named: "eyeIcon"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        eyeButton.snp.makeConstraints {
            $0.trailing.equalTo(passwordTextFieldView.snp.trailing).offset(-20)
            $0.centerY.equalTo(passwordTextFieldView)
            $0.width.height.equalTo(24)
        }
    }

    private func setupButtons() {
        xCircleButton.setImage(UIImage(named: "xCircle"), for: .normal)
        xCircleButton.snp.makeConstraints {
            $0.trailing.equalTo(eyeButton.snp.leading).offset(-20)
            $0.centerY.equalTo(passwordTextFieldView)
            $0.width.height.equalTo(24)
        }
        
        makeAccount.addTarget(self, action: #selector(presentModalView), for: .touchUpInside)
    }

    private func setupTextFieldTargets() {
        idTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        xCircleButton.addTarget(self, action: #selector(handleXCircleButtonTap), for: .touchUpInside)
    }

    // MARK: - Binding
    private func bindViewModel() {
        // 텍스트 필드 입력값 변화를 뷰 모델에 바인딩합니다.
        idTextFieldView.rx.text.orEmpty
            .bind(to: viewModel.idInput)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: disposeBag)
        
        // 뷰 모델의 로그인 버튼 활성화 여부를 버튼에 바인딩합니다.
        viewModel.isLoginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 로그인 버튼 클릭 이벤트를 처리합니다.
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .disposed(by: disposeBag)
        
        // 로그인 성공 시의 이벤트 처리를 구독합니다.
        viewModel.loginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.navigateToWelcomeScreen()
                } else {
                    self?.showError("로그인에 실패하였습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                if let message = message {
                    self?.showError(message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - AddSubview
    func addSubViews() {
        let views = [
            loginLabel,
            idTextFieldView,
            passwordTextFieldView,
            loginButton,
            findId,
            findPw,
            noAccount,
            makeAccount,
            spaceView,
            eyeButton,
            xCircleButton
        ]
        views.forEach {
            view.addSubview($0)
        }
    }
    
    // MARK: - Layout
    func setConstraints() {
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            $0.centerX.equalTo(view)
        }
        
        idTextFieldView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(view)
            $0.width.equalTo(335)
            $0.height.equalTo(52)
        }
        
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(idTextFieldView.snp.bottom).offset(20)
            $0.centerX.equalTo(view)
            $0.width.equalTo(335)
            $0.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(21)
            $0.centerX.equalTo(view)
            $0.width.equalTo(335)
            $0.height.equalTo(52)
        }
        
        findId.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(31)
            $0.leading.equalTo(view).offset(85)
        }
        
        spaceView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(loginButton.snp.bottom).offset(31)
            $0.width.equalTo(2)
            $0.height.equalTo(14)
        }
        
        findPw.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(31)
            $0.trailing.equalTo(view).offset(-86)
        }
        
        noAccount.snp.makeConstraints {
            $0.top.equalTo(findId.snp.bottom).offset(12)
            $0.leading.equalTo(view.snp.leading).offset(51)
        }
        
        makeAccount.snp.makeConstraints {
            $0.top.equalTo(findPw.snp.bottom).offset(12)
            $0.trailing.equalTo(view.snp.trailing).offset(-43)
        }
        
        // PlaceHolder 왼쪽공간 띄우기
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 10))
        idTextFieldView.leftViewMode = .always
        idTextFieldView.leftView = spacerView
        
        let spacerViewForPassword = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 10))
        passwordTextFieldView.leftViewMode = .always
        passwordTextFieldView.leftView = spacerViewForPassword
        
        findId.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(31)
        }
        
        // 오른쪽 버튼 공간 띄우기
        eyeButton.setImage(UIImage(named: "eyeIcon"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        eyeButton.snp.makeConstraints {
            $0.trailing.equalTo(passwordTextFieldView.snp.trailing).offset(-20)
            $0.centerY.equalTo(passwordTextFieldView)
            $0.width.height.equalTo(24)
        }
        
        xCircleButton.setImage(UIImage(named: "xcircle"), for: .normal)
        xCircleButton.snp.makeConstraints {
            $0.trailing.equalTo(eyeButton.snp.leading).offset(-20)
            $0.centerY.equalTo(passwordTextFieldView)
            $0.width.height.equalTo(24)
        }
    }
    
    // TF 포커스 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 테두리 색상 변경
        textField.layer.borderColor = CGColor(gray: 1, alpha: 1)
        textField.layer.borderWidth = 1.0
    }
    
    // TF 포커스 해제
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    // 텍스트가 변경될 때 호출되는 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.clearButtonMode = .whileEditing
        return true
    }
    
    func navigateToWelcomeScreen() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        do {
            let idValue = try viewModel.id.value() // BehaviorSubject에서 최신 ID 값을 가져옴
            let nicknameValue = viewModel.nickname ?? "게스트" // 올바른 닉네임 값을 사용
            print("idValue: \(idValue) \(nicknameValue)")
            welcomeVC.configureViewModel(id: idValue, nickname: nicknameValue)
        } catch {
            print("Failed to retrieve ID or nickname from ViewModel")
        }
        present(welcomeVC, animated: true, completion: nil)
    }


    func showError(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
        print(1)
    }
    
    // 비밀번호 보안처리
    @objc func togglePasswordView() {
        passwordTextFieldView.isSecureTextEntry.toggle()
    }
    
    // 지우기 버튼 눌럿을때 동작
    @objc func handleXCircleButtonTap() {
        idTextFieldView.text = ""
        passwordTextFieldView.text = ""
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.checkValid(id: idTextFieldView.text, password: passwordTextFieldView.text)
    }


    @objc func presentModalView() {
        let modalViewController = NicknameViewController()
        
        if let nicknameVC = modalViewController.presentationController as? UISheetPresentationController {
            nicknameVC.detents = [.medium()]
            nicknameVC.prefersGrabberVisible = true
        }
        
        modalViewController.onSaveNickname = { [weak self] nickname in
            self?.nickname = nickname
            print("닉네임 저장됨: \(nickname)")
        }
        present(modalViewController, animated: true, completion: nil)
    }

}
