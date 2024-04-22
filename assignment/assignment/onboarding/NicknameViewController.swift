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
    
    //MARK: - Properties
    
    var onSaveNickname: ((String) -> Void)?
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.textColor = UIColor.black
        $0.font = UIFont(name: "Pretendard-Medium", size: 23)
    }
    
    let nicknameTextField = UITextField().then {
        $0.backgroundColor = UIColor(named: "gray84")
        $0.layer.cornerRadius = 3
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "gray4")
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "gray2")])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.isUserInteractionEnabled = true
    }
    
    let saveBtn = UIButton().then {
        $0.backgroundColor = UIColor(named: "red")
        $0.setTitle("저장하기", for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(saveNickname), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        nicknameTextField.delegate = self
        
        addSubViews()
        layouts()
        setupActions()
    }
    
    //MARK: - AddSubViews
    func addSubViews() {
        let views = [
            nicknameLabel,
            nicknameTextField,
            saveBtn
        ]
        views.forEach {
            view.addSubview($0)
        }
    }
    
    //MARK: - Layouts
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
        
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(200)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    func setupActions() {
        saveBtn.addTarget(self, action: #selector(saveNickname), for: .touchUpInside)
    }
    
    
    //정규식
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if string.isEmpty { return true }
        //입력하는중에는 길이만 체크
        return prospectiveText.count <= 10
    }
    
    @objc func saveNickname() {
        if let text = nicknameTextField.text, !text.isEmpty, text.range(of: "^[가-힣]{1,10}$", options: .regularExpression) != nil {
            onSaveNickname?(text) // 클로저로 전달
            dismiss(animated: true, completion: nil)
            print(text)
        } else {
            print("닉네임을 한글 1~10자로 입력해주세요.")
        }
    }
    


}

//#Preview{
//    NicknameViewController()
//}

