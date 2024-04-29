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

    private let segmentedControl = UnderlineSegmentedControl(items: ["전체", "웹툰", "베스트도전", "ㅇㄹ", "ㄹㅇ"]).then {
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
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBar()

        // Add the segmented control and page view controller to the view hierarchy
        self.view.addSubview(self.segmentedControl)
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)

        setupConstraints()

        self.segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: self.segmentedControl)
    }

    private func setupNavigationBar() {
        let leftImage = UIImage(named: "leftTving")
        let leftButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftButtonItem

        let rightImage = UIImage(named: "rightImage")
 //       let rightButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: @objc(rightButtonAction))
    ///   navigationItem.rightBarButtonItem = rightButtonItem

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc private func rightButtonAction() {
        // Future right button functionality
    }

    private func setupConstraints() {
        self.segmentedControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
            make.height.equalTo(50)
        }

        self.pageViewController.view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(-4)
        }

        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont(name: "Pretendard-Regular", size: 14)
            ],
            for: .selected
        )
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

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: mainvc.mainCollectionView.contentOffset, size: mainvc.mainCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = mainvc.mainCollectionView.indexPathForItem(at: visiblePoint) else { return }

        if let footerView = mainvc.mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
            footerView.configure(numberOfPages: mainvc.mainCollectionView.numberOfItems(inSection: visibleIndexPath.section), currentPage: visibleIndexPath.item)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        if offset <= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

