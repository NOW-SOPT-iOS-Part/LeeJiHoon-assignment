//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController, UITextFieldDelegate {
    
    let loginLabel = UILabel().then {
        $0.text = "TVING ID 로그인"
        $0.textColor = UIColor(named: "gray84")
        $0.font = UIFont(name: "Pretendard-Medium", size: 24)
    }
    
    let idTextFieldView = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray4")
        $0.placeholder = "아이디"
        $0.layer.cornerRadius = 3
    }
    
    let passwordTextFieldView = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray4")
        $0.placeholder = "비밀번호"
        
        $0.layer.cornerRadius = 3
    }
    
    let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("로그인하기", for: .normal)
        $0.layer.cornerRadius = 3
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        idTextFieldView.delegate = self
        passwordTextFieldView.delegate = self
        
        addSubViews()
        setConstraints()
        
        // 패스워드 텍스트 필드 설정
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "eyeIcon"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        passwordTextFieldView.rightView = eyeButton
        passwordTextFieldView.rightViewMode = .always
        
    }
    
    
    func addSubViews() {
        view.addSubview(loginLabel)
        view.addSubview(idTextFieldView)
        view.addSubview(passwordTextFieldView)
        view.addSubview(loginButton)
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
        
        //PlaceHolder 왼쪽 공간 띄우기
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:22, height:10))
        idTextFieldView.leftViewMode = .always
        idTextFieldView.leftView = spacerView
        
        let spacerViewForPassword = UIView(frame:CGRect(x:0, y:0, width:22, height:10))
        passwordTextFieldView.leftViewMode = .always
        passwordTextFieldView.leftView = spacerViewForPassword
        
        
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

    @objc func textFieldDidChange(_ textField: UITextField) {
           // 두 텍스트 필드가 모두 입력되었는지 확인
           let isBothFilled = (idTextFieldView.text?.isEmpty ?? true) && (passwordTextFieldView.text?.isEmpty ?? true)
           loginButton.backgroundColor = isBothFilled ? .red : .gray
       }
}

//
//#Preview{
//    ViewController()
//}
