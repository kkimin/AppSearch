//
//  DetailViewController.swift
//  AppSearch
//
//  Created by Minju Ki on 3/23/21.
//

import UIKit
import StoreKit

protocol DetailViewDisplayLogic: class {
	func displayTestData(viewModel: InquiryCellValue)
}

class DetailViewController: BaseViewController, SearchedDataPassing, DetailViewDisplayLogic {

	private var interactor: DetailBusinessLogic?

	// MARK: - Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: - Setup

	private func setup() {
		let viewController = self
		let interactor = DatailViewInteractor()
		let presenter = DetailViewPresenter()
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}

	// MARK: - 변수 선언

	@IBOutlet weak var appImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var openBtn: UIButton!
	@IBOutlet weak var infoCollectionView: UICollectionView! 	// 정보 뷰
	@IBOutlet weak var preCollectionView: UICollectionView!		// 미리보기 뷰
	@IBOutlet weak var rateCollectionView: UICollectionView!	// 평가 뷰
	@IBOutlet weak var versionDetailLabel: UILabel!
	@IBOutlet weak var infoStackView: UIStackView!				// 정보 뷰

	var dataStore: InquiryCellValue!
	private var displayedModel: InquiryCellValue?

	private lazy var naviTitleView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private lazy var rightOpenBarItem: UIBarButtonItem = { // 여기 이제 같은걸 두고 싶은데
		let barItem = UIBarButtonItem(title: "열기", style: .plain, target: self, action: #selector(openApp))
		return barItem
	}()

	// CollectionView FlowLayout
	private lazy var infoflowLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		let height = infoCollectionView.bounds.height // infoCollectionView랑 동일
		layout.minimumLineSpacing = 2
		layout.itemSize = CGSize(width: height, height: height)
		layout.scrollDirection = .horizontal
		return layout
	}()

	private lazy var preflowLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 20
		layout.itemSize = CGSize(width: 200, height: preCollectionView.frame.height)
		layout.scrollDirection = .horizontal
		return layout
	}()

	private lazy var rateflowLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 5
		layout.itemSize = CGSize(width: view.frame.width, height: rateCollectionView.frame.height)
		layout.scrollDirection = .horizontal
		return layout
	}()

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpData()
		setUpUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		naviType = .detail
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}

	private func setUpUI() {
		naviType = .detail
		openBtn.roundCorners(.allCorners, radius: 10)
		infoCollectionView.collectionViewLayout = infoflowLayout
		preCollectionView.decelerationRate = .fast // 스크롤 시 빠르게 감속 되도록 설정
		rateCollectionView.decelerationRate = .fast
		preCollectionView.collectionViewLayout = preflowLayout
		rateCollectionView.collectionViewLayout = rateflowLayout
	}

	private func setUpData() {
		interactor?.makeTestData(data: dataStore)
	}

	// 테스트 데이터로 화면 출력
	func displayTestData(viewModel: InquiryCellValue) {
		displayedModel = viewModel
		guard let testData = displayedModel else { return }

		titleLabel.text = testData.collectionName
		subTitleLabel.text = testData.artistName
		appImageView.makePreview(url: testData.artworkUrl60)
		naviTitleView.makePreview(url: testData.artworkUrl60)
		versionDetailLabel.text = testData.versionDetail
		versionDetailLabel.setLetterSpacing(kernValue: 3.0)
		infoStackView.makeStackView(data: testData.infoContent)
	}

	// MARK: - Action

	// 열기 버튼 클릭
	@IBAction func onClickOpenBtn(_ sender: Any) {
		openApp()
	}

	@objc func openApp() {
		if let url = URL(string: displayedModel?.openURL ?? ""), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}

	// 공유하기 버튼 클릭
	@IBAction func onClickShareBtn(_ sender: Any) {
		let view = [displayedModel?.collectionName ?? ""]
		let activityVC = UIActivityViewController(activityItems: view, applicationActivities: nil)
		self.present(activityVC, animated: true, completion: nil)
	}

	// 새로운 기능 더보기 클릭
	@IBAction func onClickSeeMore(_ sender: UIButton) {
		sender.isHidden = true
		versionDetailLabel.numberOfLines = 0
		versionDetailLabel.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
	}

	// 탭하여 평가하기 클릭
	@IBAction func onClickReviewBtn(_ sender: Any) {
		SKStoreReviewController.requestReview() // 평가하시겠습니까?
	}

	// 리뷰 작성하기 클릭
	@IBAction func onClickWriteReview(_ sender: Any) {
		doReview()
	}
}

// MARK: - SKStoreProductViewControllerDelegate

extension DetailViewController: SKStoreProductViewControllerDelegate {
	func doReview() { // itunes 열기
		let viewController = SKStoreProductViewController()
		viewController.delegate = self
		let parameters = [
			SKStoreProductParameterITunesItemIdentifier: Constants.exampleIBooksID // use apple example
		]
		viewController.loadProduct(withParameters: parameters, completionBlock: nil)
		self.present(viewController, animated: true, completion: nil)
	}

	func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
		viewController.dismiss(animated: true, completion: nil)
	}
}

// MARK: - UIScrollViewDelegate

extension DetailViewController {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView != baseScrollView { return }
		if scrollView.contentOffset.y > Constants.hidePoint, navigationItem.titleView == nil { // navigation bar animation
			navigationItem.titleView = naviTitleView
			navigationItem.rightBarButtonItem = rightOpenBarItem
		} else if scrollView.contentOffset.y < Constants.hidePoint, navigationItem.titleView != nil {
			navigationItem.titleView = nil
			navigationItem.rightBarButtonItem = nil
		}
	}

	// preCollectionView의 스크롤 애니메이션(paging)
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if !(scrollView == preCollectionView || scrollView == rateCollectionView) { return }
		let layout = (scrollView == preCollectionView) ? preflowLayout : rateflowLayout
		let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
		let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
		let index: Int
		if velocity.x > 0 {
			index = Int(ceil(estimatedIndex))
		} else if velocity.x < 0 {
			index = Int(floor(estimatedIndex))
		} else {
			index = Int(round(estimatedIndex))
		}
		targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == infoCollectionView {
			return displayedModel?.infoCollectionData.count ?? 0
		}
		return Constants.testCollectionViewCount
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == preCollectionView {
			let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PreCollectionCell", for: indexPath) as? PreCollectionCell)!
			return cell
		} else if collectionView == rateCollectionView {
			let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "RateCollectionCell", for: indexPath) as? RateCollectionCell)!
			return cell
		} else {
			let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCell", for: indexPath) as? StatusCell)!
			guard let data = displayedModel?.infoCollectionData[indexPath.row] else {
				return cell
			}
			cell.configureCell(by: data)
			return cell
		}
	}
}

// MARK: - Constants

extension DetailViewController {
	enum Constants {
		static let naviTitle = "검색"
		static let topTitleMargin: CGFloat = 35
		static let exampleIBooksID: String = "364709193"
		static let hidePoint: CGFloat = 40
		static let testCollectionViewCount: Int = 10
	}
}
