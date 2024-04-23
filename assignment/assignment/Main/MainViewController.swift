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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupCollectionView()

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
            $0.edges.equalToSuperview()
        }
    }

    
    
    // MARK: - UICollectionViewDataSource
    private func getLayoutContentsSection() -> NSCollectionLayoutSection {
    
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),  // 한 줄에 3개의 아이템이 나타나도록 설정 -> 비율이 아닌 고정값으로 때려박았더니 그룹갯수 수정이슈 해결 야호!
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
        switch dataSource[section] {
        case .mainContents(let contents, _):
            return contents.count
        case .freeContents(let contents, _):
            return contents.count
        case .magicContents(let contents, _):
            return contents.count
        case .live(let contents, _):
            return contents.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }


    
    //Header, Footer 지정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TitleHeaderViewCollectionViewCell",
                for: indexPath
            ) as! TitleHeaderViewCollectionViewCell
            switch dataSource[indexPath.section] {
            case .mainContents(_, let title):
                header.prepare(titleText: title, subtitleText: "전체보기")
            case .freeContents(_, let title):
                header.prepare(titleText: title, subtitleText: "전체보기")
            case .magicContents(_, let title):
                header.prepare(titleText: title, subtitleText: "전체보기")
            case .live(_, let title):
                header.prepare(titleText: title, subtitleText: "전체보기")
            }
            return header

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

#Preview {
    MainViewController()
}
