//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//

import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
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
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Before setting clearButtonMode: \(idTextFieldView.clearButtonMode.rawValue)")
            
            idTextFieldView.clearButtonMode = .never
            passwordTextFieldView.clearButtonMode = .never

            print("After setting clearButtonMode: \(idTextFieldView.clearButtonMode.rawValue)")
            
        
        view.backgroundColor = .black
        idTextFieldView.delegate = self
        passwordTextFieldView.delegate = self
        
        addSubViews()
        setConstraints()
        
        // 패스워드 텍스트 필드 설정
        eyeButton.setImage(UIImage(named: "eyeIcon"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        eyeButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextFieldView.snp.trailing).offset(-20)
            make.centerY.equalTo(passwordTextFieldView)
            make.width.height.equalTo(24)
        }
        
        xCircleButton.setImage(UIImage(named: "xCircle"), for: .normal)
        xCircleButton.snp.makeConstraints { make in
            make.trailing.equalTo(eyeButton.snp.leading).offset(-20)
            make.centerY.equalTo(passwordTextFieldView)
            make.width.height.equalTo(24)
        }
        //
        idTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        xCircleButton.addTarget(self, action: #selector(handleXCircleButtonTap), for: .touchUpInside)

        makeAccount.addTarget(self, action: #selector(presentModalView), for: .touchUpInside)

        

    }
    
    //MARK: - AddSubview
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
            view.addSubview(
                $0
            )
        }
        
    }
    
    
    
    //MARK: - layout
    func setConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            make.centerX.equalTo(view)
        }
        
        idTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(335)
            make.height.equalTo(52)
            
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(idTextFieldView.snp.bottom).offset(20)
            
            make.centerX.equalTo(view)
            make.width.equalTo(335)
            make.height.equalTo(52)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(21)
            
            make.centerX.equalTo(view)
            make.width.equalTo(335)
            make.height.equalTo(52)
        }
        
        findId.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(31)
            make.leading.equalTo(view).offset(85)
        }
        
        spaceView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(loginButton.snp.bottom).offset(31)
            make.width.equalTo(2)
            make.height.equalTo(14)
        }
        
        
        findPw.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(31)
            make.trailing.equalTo(view).offset(-86)
        }
        
        noAccount.snp.makeConstraints { make in
            make.top.equalTo(findId.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(51)
        }
        
        makeAccount.snp.makeConstraints { make in
            make.top.equalTo(findPw.snp.bottom).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-43)
        }
        
        //PlaceHolder 왼쪽공간 띄우기
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:22, height:10))
        idTextFieldView.leftViewMode = .always
        idTextFieldView.leftView = spacerView
        
        let spacerViewForPassword = UIView(frame:CGRect(x:0, y:0, width:22, height:10))
        passwordTextFieldView.leftViewMode = .always
        passwordTextFieldView.leftView = spacerViewForPassword
        
        findId.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(31)
            
        }
        
        //오른쪽 버튼 공간 띄우기
        eyeButton.setImage(UIImage(named: "eyeIcon"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        eyeButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextFieldView.snp.trailing).offset(-20)
            make.centerY.equalTo(passwordTextFieldView)
            make.width.height.equalTo(24)
        }
        
        xCircleButton.setImage(UIImage(named: "xcircle"), for: .normal)
        xCircleButton.snp.makeConstraints { make in
            make.trailing.equalTo(eyeButton.snp.leading).offset(-20)
            make.centerY.equalTo(passwordTextFieldView)
            make.width.height.equalTo(24)
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
    
    @objc func togglePasswordView() {
        passwordTextFieldView.isSecureTextEntry.toggle()
    }
    
    //텍스트 필드 채워졌는지 확인
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isBothFilled = !(idTextFieldView.text?.isEmpty ?? true) && !(passwordTextFieldView.text?.isEmpty ?? true)
        loginButton.backgroundColor = isBothFilled ? .red : .clear
    }
    
    @objc func handleXCircleButtonTap() {
            // 사용자가 입력한 텍스트를 출력하고 필드를 지웁니다.
            print("ID: \(idTextFieldView.text ?? "")")
            print("Password: \(passwordTextFieldView.text ?? "")")
            idTextFieldView.text = ""
            passwordTextFieldView.text = ""
        }
    
    @objc func presentModalView() {
        let modalViewController = NicknameViewController()
        
        if let nicknameVC = modalViewController.presentationController as? UISheetPresentationController {
            nicknameVC.detents = [.medium()]
        }
        self.present(modalViewController, animated: true, completion: nil)
    }

}
//
//#Preview{
//    LoginViewController()
//}
