//
//  LiveCell.swift
//  assignment
//
//  Created by 이지훈 on 4/30/24.
//

import UIKit
import Then
import SnapKit

class LiveContentCell: UICollectionViewCell {

    static let identifier = "LiveContentCell"

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.textColor = .white
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.textColor = UIColor(named: "gray2")
    }

    private let literLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.textColor = UIColor(named: "gray2")
    }

    private let awardLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.textColor = .white
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

        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(1)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }

        literLabel.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }

        awardLabel.snp.makeConstraints {
            $0.top.equalTo(self.literLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
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
