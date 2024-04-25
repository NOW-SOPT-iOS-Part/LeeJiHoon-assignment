//
//  MainViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit
import Then
import SnapKit

class MainViewController: UIViewController {
    
    private var mainCollectionView : UICollectionView!
    private var dataSource = MainModel.dummy()
    
    //carousel 크기 설정
    private enum Const {
        static let itemSize = CGSize(width: 300, height: 400)
        static let itemSpacing = 24.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
        }
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    //carousel
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize
        layout.minimumLineSpacing = Const.itemSpacing
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.cellId)
            $0.isPagingEnabled = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.contentInset = Const.collectionViewContentInset
            $0.decelerationRate = .fast
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCarouselCollectionView() // Carousel을 먼저 설정하고
          setupCollectionView()
        registerCollectionViewHeader()

    }
    
    
    func registerCollectionViewHeader() {
        mainCollectionView.register(CarouselCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CarouselCollectionViewCell.cellId)
    }
    
    func carouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header()]

        return section
    }

    func header() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }

    
     func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self, sectionIndex < self.dataSource.count else { return nil }
            
            let sectionType = self.dataSource[sectionIndex]
            
            //셀 종류별로 모음
            switch sectionType {
            case .mainContents:
                return self.getLayoutContentsSection()
            case .freeContents:
                return self.getLayoutContentsSection()
            case .magicContents:
                return self.getLayoutContentsSection()
            case .live:
                return self.getLayoutLiveSection()
            default:
                return nil
            }
        }
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = true
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            
            $0.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
            $0.register(TitleHeaderViewCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeaderViewCollectionViewCell")
            $0.register(DoosanFooterViewCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
            
            $0.dataSource = self
        }
        
        self.view.addSubview(mainCollectionView)
         mainCollectionView.snp.makeConstraints {
             $0.top.equalTo(collectionView.snp.bottom) // Carousel 아래에 배치
             $0.left.right.bottom.equalTo(view)
             }
    }
    
    // MARK: - Carousel CollectionView
    func setupCarouselCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view) // 최상단에 고정
            make.height.equalTo(Const.itemSize.height) // 높이 설정
        }
    }

    
    // MARK: - 기본 컨텐츠
    private func getLayoutContentsSection() -> NSCollectionLayoutSection {
        
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),  //비율이 아닌 고정값으로 때려박았더니 그룹갯수 이슈 해결 야호!
            heightDimension: .fractionalHeight(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),  // 그룹 너비를 컬렉션 뷰의 전체 너비와 동일하게 설정
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
            
        )
        
        //title Text + 전체보기
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .estimated(11)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
    
    //MARK: - live cell
    private func getLayoutLiveSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(1.0/4.0)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return 5 // Assuming there are 5 carousel items
        } else {
            switch dataSource[section] {
            case .mainContents(let contents, _):
                return contents.count
            case .freeContents(let contents, _):
                return contents.count
            case .magicContents(let contents, _):
                return contents.count
            case .live(let contents, _):
                return contents.count
            } //  한번에 return을 주면 타입오류남 -> 각 케이스별 타입을 개별로 주어 타입오류 없앰
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.cellId, for: indexPath) as! CarouselCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
            switch dataSource[indexPath.section] {
            case .mainContents(let contents, _):
                let content = contents[indexPath.item]
                cell.mainCollectionConfigure(image: content.image, title: content.title)
            case .freeContents(let contents, _):
                let content = contents[indexPath.item]
                cell.mainCollectionConfigure(image: content.image, title: content.title)
            case .magicContents(let contents, _):
                let content = contents[indexPath.item]
                cell.mainCollectionConfigure(image: content.image, title: content.title)
            case .live(let contents, _):
                let content = contents[indexPath.item]
                cell.mainCollectionConfigure(image: content.image, title: content.title)
            }
            return cell
        } //  한번에 return을 주면 타입오류남 -> 각 케이스별 타입을 개별로 주어 타입오류 없앰
    }
    
    
    
    //Header, Footer 지정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            // Carousel 헤더를 첫 번째 섹션에 적용
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CarouselCollectionViewCell.cellId,
                    for: indexPath
                ) as! CarouselCollectionViewCell
                // Carousel 셀 구성 코드
                // 예: header.configure(image: UIImage(named: "image_name"), text: "Optional Text")
                return header
            } else {
                // 다른 섹션의 헤더 처리
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "TitleHeaderViewCollectionViewCell",
                    for: indexPath
                ) as! TitleHeaderViewCollectionViewCell
                switch dataSource[indexPath.section - 1] {  // 첫 번째 섹션은 Carousel이므로 인덱스 조정
                case .mainContents(_, let title), .freeContents(_, let title), .magicContents(_, let title), .live(_, let title):
                    header.prepare(titleText: title, subtitleText: "전체보기")
                }
                return header
            }
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "FooterView",
                for: indexPath
            )
            return footer
            
        default:
            fatalError("Unexpected element kind")
        }
    }
}

//carousel
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}


#Preview {
    MainViewController()
}
