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
    
    //MARK: - Properties
    private var mainCollectionView : UICollectionView!
    private var dataSource = MainModel.dummy() // 나와라 더미데이터

    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }

    
    //   MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
    }

    
    
    private func setupNavigationBar() {
        
        // 네비게이션 바 왼쪽 아이템 설정
        let leftImage = UIImage(named: "leftTving") // 왼쪽 이미지 이름으로 변경
        
        // 네비게이션 바 오른쪽 아이템 설정
        let rightImage = UIImage(named: "rightImage") // 오른쪽 이미지 이름으로 변경
        let rightButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(rightButtonAction))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func rightButtonAction() {
        // 추후 오른쪽 버튼 클릭 시 수행할 동작
    }
   
    
    //섹션 레이아웃 설정
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self, sectionIndex < self.dataSource.count else { return nil }

            let sectionType = self.dataSource[sectionIndex]

            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom)

            switch sectionType {
            case .headContent(let contents):
                return self.getLayoutHeaderSection(contents: contents)
            case .mainContents, .freeContents, .magicContents:
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
            $0.contentInsetAdjustmentBehavior = .never
            $0.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
            $0.register(TitleHeaderViewCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeaderViewCollectionViewCell")
            $0.register(DoosanFooterViewCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
            $0.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomFooterView.identifier)
            $0.dataSource = self
            $0.delegate = self
        }

        self.view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    
    // MARK: - getLayoutHeaderSection
    private func getLayoutHeaderSection(contents: [HeadContent]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500)) //image크기는 고정값 나머지는 비율로
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        //페이징 인디케이터 푸터
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    
    // MARK: - getLayoutContentsSection
    private func getLayoutContentsSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(0.25)
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
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    
    //MARK: - getLayoutLiveSection
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
        
        let sectionType = dataSource[section]
        
        switch sectionType {
        case .headContent(let contents):
            return contents.count
            
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
        let sectionType = dataSource[indexPath.section]
        switch sectionType {
            
        case .headContent(let contents):
            let content = contents[indexPath.item]
            cell.configure(image: content.image, title: "", isFullWidth: true)
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeaderViewCollectionViewCell", for: indexPath) as! TitleHeaderViewCollectionViewCell
            let sectionType = dataSource[indexPath.section]
            switch sectionType {
            case .mainContents(_, let title),
                    .freeContents(_, let title),
                    .magicContents(_, let title),
                    .live(_, let title):
                header.prepare(titleText: title, subtitleText: "전체보기")
            default:
                header.prepare(titleText: "", subtitleText: "")
            }
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomFooterView.identifier, for: indexPath) as! CustomFooterView
            footer.configure(numberOfPages: collectionView.numberOfItems(inSection: indexPath.section), currentPage: indexPath.row)
            return footer
            
        default:
            fatalError("Unexpected element kind")
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: mainCollectionView.contentOffset, size: mainCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = mainCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        if let footerView = mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
            footerView.configure(numberOfPages: mainCollectionView.numberOfItems(inSection: visibleIndexPath.section), currentPage: visibleIndexPath.item)
        }
    }
    
    //scrollview 높이 따라서 네비게이션 바 노출여부
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}


//
//
//#Preview {
//    MainViewController()
//}
