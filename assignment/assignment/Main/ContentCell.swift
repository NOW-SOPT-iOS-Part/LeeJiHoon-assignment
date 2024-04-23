//
//  ContentCell.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit
import SnapKit
import Then


class ContentCell: UICollectionViewCell {
    
    static let identifier = "ContentCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let optionButton = UIButton().then {
        $0.setImage(UIImage(named: "right-arrow"), for: .normal)
        $0.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionButton)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
            $0.width.equalTo(98)
            $0.height.equalTo(148)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        optionButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalTo(imageView.snp.centerY)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func mainCollectionConfigure(image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}

