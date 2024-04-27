//
//  CarouselCollectionViewCell.swift
//  assignment
//
//  Created by 이지훈 on 4/25/24.
//

import UIKit
import SnapKit
import Then
import LookinServer
// CarouselCollectionViewCell.swift
class CarouselCollectionViewCell: UICollectionViewCell {
    static let cellId = "CarouselCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()

    private var currentIndex = 0
    private let images = [UIImage(named: "mainContents")!, UIImage(named: "mainContents")!, UIImage(named: "mainContents")!]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
            make.centerX.equalTo(contentView)
        }
    }

    private func updateImageDisplay() {
        imageView.image = images[currentIndex % images.count]
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentIndex % images.count
    }
}
