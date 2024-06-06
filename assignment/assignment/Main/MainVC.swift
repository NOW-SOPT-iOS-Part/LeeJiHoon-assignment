//
//  MainViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit
import Then
import SnapKit
import Moya

class MainViewController: UIViewController {
    
    //MARK: - Properties
    var mainCollectionView : UICollectionView!
    
    var dataSource = MainModel(sections: [])
    
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
        
        setupCollectionView()
        
    }

    // 전체 UI의 일부분만 API로 업데이트 해서 생긴 로직
    func updateMainModel(with movies: [Movie]) {
        let newContents = movies.map { movie in
            Content(image: UIImage(named: "contents1") ?? UIImage(), title: movie.movieNm)
        }
        let newMainContents = SectionType.mainContents(contents: newContents, title: "티빙에서 꼭 봐야하는 컨텐츠")
        
        var updatedSections = MainModel.dummy()
        
        // api로 받은 데이터를 더미 데이터 리스트의 1번째 위치에 삽입
        if updatedSections.count > 1 {
            updatedSections.insert(newMainContents, at: 1) // 1번째 위치에 삽입
        } else {
            updatedSections.append(newMainContents) // 더미 데이터가 없으면 그냥 추가
        }
        
        // 데이터 소스 업데이트
        dataSource.sections = updatedSections
    }
    
    
    //섹션 레이아웃 설정
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self, sectionIndex < self.dataSource.sections.count else { return nil }
            
            let sectionType = self.dataSource.sections[sectionIndex]
            
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
            case .DoosanContent(let contents):
                return self.getLayoutDoosanSection(contents: contents)
                
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
            $0.register(DoosanFooterViewCollectionViewCell.self, forCellWithReuseIdentifier: DoosanFooterViewCollectionViewCell.identifier)
            $0.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomFooterView.identifier)
            $0.register(LiveContentCell.self, forCellWithReuseIdentifier: LiveContentCell.identifier)
            
            $0.dataSource = self
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
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(0.46)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        // Group s
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(7) // 그룹간 거리 7로 고정
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    //MARK: - DoosanCell
    // Function to get the layout for the Doosan section
    private func getLayoutDoosanSection(contents: [DoosanContent]) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(0.8)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100) )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }

}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionType = dataSource.sections[section]
        
        switch sectionType {
        case .headContent(let contents):
            return contents.count
            
        case .mainContents(let contents, _):
            return contents.count
        case .freeContents(let contents, _):
            return contents.count
        case .live(let contents, _):
            return contents.count
        case .magicContents(let contents, _):
            return contents.count
        case .DoosanContent(let contents):
            return contents.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = dataSource.sections[indexPath.section]
        
        switch sectionType {
        case .headContent(let contents):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.configure(image: content.image, title: "", isFullWidth: true)
            return cell
            
        case .mainContents(let contents, _):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.mainCollectionConfigure(image: content.image, title: content.title)
            return cell
            
        case .freeContents(let contents, _):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.mainCollectionConfigure(image: content.image, title: content.title)
            return cell
            
        case .magicContents(let contents, _):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.mainCollectionConfigure(image: content.image, title: content.title)
            return cell
            
        case .live(let contents, _):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveContentCell.identifier, for: indexPath) as! LiveContentCell
            cell.configures(content: content)
            return cell
        case .DoosanContent(let contents):
            let content = contents[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoosanFooterViewCollectionViewCell.identifier, for: indexPath) as! DoosanFooterViewCollectionViewCell
            cell.configure(image: content.image)
            return cell
        }
    }
    
    
    //Header, Footer 지정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeaderViewCollectionViewCell", for: indexPath) as! TitleHeaderViewCollectionViewCell
            let sectionType = dataSource.sections[indexPath.section]
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

//#Preview {
//    MainViewController()
//}
