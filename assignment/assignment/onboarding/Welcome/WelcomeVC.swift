//
//  WelcomeViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/12/24.

import UIKit

import Then
import SnapKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func didLoginWithId(id: String)
}

class WelcomeViewController: UIViewController {
    
    weak var delegate: WelcomeViewControllerDelegate?
    
    private var viewModel: WelcomeViewModelType = WelcomeViewModel()
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "tving")
        $0.contentMode = .scaleToFill
    }
    
    let welcomeLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray84")
        $0.font = UIFont(name: "Pretendard-Bold", size: 23)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    let backButton = UIButton().then {
        $0.setTitle("메인으로", for: .normal)
        $0.backgroundColor = UIColor(named: "red")
        $0.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configureLabel()
        backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        addSubViews()
        setLayouts()
        bindViewModel()
        
        print(viewModel.id.value)
        print(viewModel.nickname.value ?? "No nickname")
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.welcomeMessage.bind { [weak self] message in
            self?.welcomeLabel.text = message
        }
    }
    
    func configureLabel() {
        viewModel.configureWelcomeMessage()
    }
    
    func addSubViews() {
        let views = [imageView, welcomeLabel, backButton]
        views.forEach { view.addSubview($0) }
    }
    
    func setLayouts() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(58)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(67)
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-66)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(52)
        }
    }
    
    @objc func backToMain() {
        let mainVC = MainViewController()
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(mainVC, animated: true)
        }
    }
    
    // Assign values to the viewModel
    func configureViewModel(id: String, nickname: String?) {
        viewModel.id.value = id
        viewModel.nickname.value = nickname
        viewModel.configureWelcomeMessage()
    }
}
