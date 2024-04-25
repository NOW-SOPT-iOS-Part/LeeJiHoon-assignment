//
//  CarouselCollectionViewCell.swift
//  assignment
//
//  Created by 이지훈 on 4/25/24.
//
import UIKit
import Then
import SnapKit

class CarouselCollectionViewCell: UICollectionViewCell {

    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    
    static let cellId = "CarouselCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Setups

extension CarouselCollectionViewCell {
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}

// MARK: - Public

extension CarouselCollectionViewCell {
    public func configure(image: UIImage?) {
        imageView.image = image
    }
}
