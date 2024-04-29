//
//  LiveCell.swift
//  assignment
//
//  Created by 이지훈 on 4/30/24.
//

import UIKit


class LiveContentCell: UICollectionViewCell {

    static let identifier = "LiveContentCell"

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .darkGray
    }

    private let literLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .darkGray
    }

    private let awardLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(literLabel)
        addSubview(awardLabel)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.frame.height / 2)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(4)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.equalTo(titleLabel)
        }

        literLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(2)
            make.left.equalTo(subTitleLabel)
        }

        awardLabel.snp.makeConstraints { make in
            make.centerY.equalTo(literLabel)
            make.right.equalToSuperview().offset(-4)
        }
    }

    func configures(content: LiveContent) {
        imageView.image = content.image
        titleLabel.text = content.title
        subTitleLabel.text = content.subTitle
        literLabel.text = content.liter
        awardLabel.text = "\(content.award)"
    }
}
