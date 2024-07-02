//  WelcomeViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/12/24.
import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    private var viewModel: WelcomeViewModelType?
    private let disposeBag = DisposeBag()

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

        addSubViews()
        setLayouts()

        if let viewModel = viewModel {
            bindViewModel(viewModel)
        }
        
        backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
    }

    func configureViewModel(id: String, nickname: String) {
        let viewModel = WelcomeViewModel()
        viewModel.id.accept(id)
        viewModel.nickname.accept(nickname)
        self.viewModel = viewModel
        bindViewModel()
        print("id: \(id)")
        print("nickname : \(nickname)")
    }

    private func bindViewModel() {
        viewModel?.welcomeMessage
            .bind(to: welcomeLabel.rx.text)
            .disposed(by: disposeBag)
    }


    private func bindViewModel(_ viewModel: WelcomeViewModelType) {
        viewModel.welcomeMessage
            .bind(to: welcomeLabel.rx.text)
            .disposed(by: disposeBag)
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
        let mainVC = RootCollectionViewController()
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
}
