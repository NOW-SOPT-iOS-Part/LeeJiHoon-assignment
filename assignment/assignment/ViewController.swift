//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    let loginLabel = UILabel().then {
        $0.text = "TVING ID 로그인"
        $0.textColor = UIColor(named: "gray84")
        $0.font = UIFont(name: "Pretendard-Medium", size: 24)
    }
    
    let idTextFieldView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let passwordTextFieldView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        addSubViews()
        setConstraints()
    }
    
    func addSubViews() {
        view.addSubview(loginLabel)
        view.addSubview(idTextFieldView)
        view.addSubview(passwordTextFieldView)
    }
    
    func setConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
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
    }
}


#Preview{
    ViewController()
}
