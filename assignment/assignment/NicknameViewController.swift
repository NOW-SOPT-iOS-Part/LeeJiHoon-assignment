//
//  NicknameViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/12/24.
//
import UIKit
import SnapKit
import Then

class NicknameViewController: UIViewController, UITextFieldDelegate {

    let nicknameLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.textColor = UIColor.black
        $0.font = UIFont(name: "Pretendard-Medium", size: 23)
    }
    
    let nicknameTextField = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray4")
        $0.layer.cornerRadius = 3
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "gray2")])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    let saveBtn = UIButton().then {
        $0.backgroundColor = UIColor(named: "gray4")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        nicknameTextField.delegate = self
        addSubViews()
        layouts()
    }
    
    func addSubViews() {
        let views = [
            nicknameLabel,
            nicknameTextField
        ]
        views.forEach {
            view.addSubview($0)
        }
    }
    
    func layouts() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true } // 백스페이스 허용
        return string.range(of: "^[가-힣]*$", options: .regularExpression) != nil
    }

    
}
//
//#Preview{
//    NicknameViewController()
//}
