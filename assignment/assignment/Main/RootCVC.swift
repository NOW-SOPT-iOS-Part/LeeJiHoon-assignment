//
//  RootCollectionViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/29/24.
//

import UIKit
import SnapKit
import Then

class RootCollectionViewController: UIViewController {
    
    private let viewModel = RootViewModel()
    
    private lazy var segmentedControl = UnderlineSegmentedControl(items: viewModel.getSegmentTitles()).then {
           $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
           $0.backgroundColor = .clear
       }
       
       private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
           $0.delegate = viewModel
           $0.dataSource = viewModel
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        viewModelBinding()
    }
    
    private func viewModelBinding() {
        viewModel.onPageChanged = { [weak self] index in
            self?.segmentedControl.selectedSegmentIndex = index
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.setupCollectionViewDelegate()
        }
        
        viewModel.updatePage(to: 0) { [weak self] viewController, direction in
            self?.pageViewController.setViewControllers([viewController], direction: direction, animated: false, completion: nil)
        }
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupSegmentsAndPageView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let leftImage = UIImage(named: "leftTving")
        let leftButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftButtonItem
        
        let rightImage = UIImage(named: "rightImage")
        let rightButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func setupSegmentsAndPageView() {
        view.addSubview(segmentedControl)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        view.bringSubviewToFront(segmentedControl)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionViewDelegate() {
        if let mainvc = viewModel.mainViewController() {
            mainvc.mainCollectionView.delegate = self
        }
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        viewModel.setSelectedSegmentIndex(control.selectedSegmentIndex)
        viewModel.updatePage(to: control.selectedSegmentIndex) { [weak self] viewController, direction in
            self?.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
}

extension RootCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView, navigationController: navigationController)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating(scrollView) { visibleIndexPath, numberOfItems, currentPage in
            if let mainvc = viewModel.mainViewController(), let footerView = mainvc.mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
                footerView.configure(numberOfPages: numberOfItems, currentPage: currentPage)
            }
        }
    }
}
