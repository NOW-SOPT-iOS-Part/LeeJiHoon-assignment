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
        $0.font = UIFont(name: "Pretendard-Regular", size: 20)
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
            $0.top.equalToSuperview()
            $0.width.equalTo(130)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, literLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.left.equalTo(awardLabel.snp.right).offset(10)
        }
        
        awardLabel.snp.makeConstraints {
            $0.top.equalTo(stackView)
            $0.left.equalToSuperview().offset(8)
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
