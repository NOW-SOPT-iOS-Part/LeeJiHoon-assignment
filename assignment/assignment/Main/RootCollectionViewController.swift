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
    
    private let segmentedControl = UnderlineSegmentedControl(items: ["홈", "실시간", "TV프로그램", "영화", "파라마운트+"]).then {
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        $0.backgroundColor = .clear
    }
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    private let mainvc = MainViewController()
    private let vc2 = UIViewController().then { $0.view.backgroundColor = .green }
    private let vc3 = UIViewController().then { $0.view.backgroundColor = .blue }
    private let vc4 = UIViewController().then { $0.view.backgroundColor = .white }
    private let vc5 = UIViewController().then { $0.view.backgroundColor = .black }
    
    var dataViewControllers: [UIViewController] {
        [self.mainvc, self.vc2, self.vc3, self.vc4, self.vc5]
    }
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]], direction: direction, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupSegmentsAndPageView()
        setupConstraints()
        
        setupInitialState()
        setupCollectionViewDelegate()
        
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
        
        view.bringSubviewToFront(segmentedControl) // 앞으로 땡겨오기
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
    
    private func setupInitialState() {
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }
    
    private func setupCollectionViewDelegate() {
        mainvc.mainCollectionView.delegate = self
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

extension RootCollectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0], let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

extension RootCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let isScrollingDown = offset > 0
        
        navigationController?.setNavigationBarHidden(isScrollingDown, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let visibleIndexPath = mainvc.mainCollectionView.indexPathForItem(at: CGPoint(x: mainvc.mainCollectionView.contentOffset.x + mainvc.mainCollectionView.bounds.width / 2, y: mainvc.mainCollectionView.contentOffset.y + mainvc.mainCollectionView.bounds.height / 2)) else { return }
        
        if let footerView = mainvc.mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
            footerView.configure(numberOfPages: mainvc.mainCollectionView.numberOfItems(inSection: visibleIndexPath.section), currentPage: visibleIndexPath.item)
        }
    }
}
