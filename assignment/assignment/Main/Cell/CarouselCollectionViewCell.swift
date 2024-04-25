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
    
    private let logoImages: [UIImage] = [
        UIImage(named: "mainContents")!,
        UIImage(named: "mainContents")!,
        UIImage(named: "mainContents")!,
        UIImage(named: "mainContents")!,
        UIImage(named: "mainContents")!
    ]
    
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startCarousel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        startCarousel()
    }
    
    // MARK: - Carousel
    
    private func startCarousel() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateCarouselImage()
        }
    }
    
    private func updateCarouselImage() {
        imageView.image = logoImages[currentIndex]
        currentIndex = (currentIndex + 1) % logoImages.count
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
            make.height.equalTo(375)
        }
    }
}

