//
//  MainSearchViewController.swift
//  AppSearch
//
//  Created by 기민주 on 2021/03/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainSearchDisplayLogic: class {
	func displaySomething(viewModel: MainSearch.ViewModel)
	func displayRecent(viewModel: SearchedModel.ViewModel)
}

protocol SearchedDataPassing {
	var dataStore: InquiryCellValue! { get }
}

class MainSearchViewController: BaseViewController, MainSearchDisplayLogic, SearchedDataPassing {
	var dataStore: InquiryCellValue!
	var interactor: MainSearchBusinessLogic?
	// MARK: Object lifecycle

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
		let interactor = MainSearchInteractor()
		let presenter = MainSearchPresenter()
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}

	// MARK: - Outlet 변수 선언

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleTopConstraint: NSLayoutConstraint!

	private var filteredData = SearchedModel.ViewModel(searchedList: [""])
	private var allRecentData = SearchedModel.ViewModel(searchedList: [""])
	private var displayedResult: [InquiryCellValue] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	private var status: SearchStatus = .nothing

	// MARK: - View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		setupTableView()
		setupSearchBar()

		// 최근 검색어 가져오기
		fetchRecentList()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		naviType = .main
	}

	// 테이블 뷰 초기 세팅
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.estimatedRowHeight = Constants.tableViewCellSize
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))   // 마지막 cell separator hidden
		tableView.rowHeight = UITableView.automaticDimension
		tableView.allowsSelection = true
	}

	// UISearchBar 초기 세팅
	private func setupSearchBar() {
		searchBar.delegate = self
		searchBar.placeholder = "게임, 앱, 스토리 등"
	}

	// MARK: - get Data

	/// 최근 검색어 가져오기
	private func fetchRecentList() {
		view.isUserInteractionEnabled = false // loading
		interactor?.getRecentData()
	}

	/// 검색 결과 가져오기
	func fetchSearchList(_ text: String?) {
		view.isUserInteractionEnabled = false // loading
		let request = MainSearch.Request(searchText: text ?? "")
		interactor?.doSearch(request: request)
		filteredData.searchedList.append(request.searchText)
		allRecentData.searchedList.append(request.searchText)
	}

	/// 최근 검색어 받아옴
	func displayRecent(viewModel: SearchedModel.ViewModel) {
		view.isUserInteractionEnabled = true // loading exit
		filteredData = viewModel // 검색을 위한 최근 검색어 viewModel
		allRecentData = viewModel // 전체 최근 검색어 list
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	/// 검색 결과 통신 후
	func displaySomething(viewModel: MainSearch.ViewModel) {
		DispatchQueue.main.async {
			self.view.isUserInteractionEnabled = true // loading exit
			if viewModel.listCount == nil { // 실패한 케이스
				self.clearData()
				self.searchBar.text = "통신 오류"
			} else {
				self.status = .searched
				self.displayedResult = viewModel.displayedResult
			}
		}
	}
}

// MARK: - MainSearchViewController UITableViewDataSource, UITableViewDelegate

extension MainSearchViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch status {
		case .searching, .nothing:
			return filteredData.searchedList.count
		case .searched:
			return displayedResult.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch status {
		case .searching, .nothing:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "RecentSearchedCell") as? RecentSearchedCell)!
			let displayedList = filteredData.searchedList[indexPath.row]
			cell.configureCell(by: displayedList)
			return cell
		case .searched:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "MainSearchCell") as? MainSearchTableViewCell)!
			cell.configureCell(by: displayedResult[indexPath.row])
			return cell
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch status {
		case .searching, .nothing:
			searchBar.text = filteredData.searchedList[indexPath.row]
			setActiveSearchBar()
			fetchSearchList(searchBar.text)
		case .searched:
			dataStore = displayedResult[indexPath.row]
			if let viewController = getViewController(storyboardName: "MainSearch", identifier: "DetailView") as? DetailViewController {
				viewController.dataStore = dataStore
				navigationController?.pushViewController(viewController, animated: true)
			}
			return
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	// TableView Section View 구성
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionView = getRecentSectionViewFromXib()
		sectionView.titleLabel.text = status == .searched ? "검색 결과" : "최근 검색어"
		return sectionView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return Constants.sectionHeight
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return Constants.sectionViewCount
	}

	/// RecentSectionView.xib에서 section header view로 사용할 UIView를 가져온다.
	private func getRecentSectionViewFromXib() -> RecentSectionView {
		guard let sectionHeader = Bundle.main.loadNibNamed("RecentSectionView", owner: self, options: nil)?[0] as? RecentSectionView else {
			#if DEBUG
			print("RecentSectionView xib를 찾을 수 없습니다.")
			#endif
			return RecentSectionView.init()
		}
		return sectionHeader
	}
}

// MARK: - Constants

extension MainSearchViewController {
	enum Constants {
		static let naviTitle = "검색"
		static let topTitleMargin: CGFloat = 35
		static let tableViewCellSize: CGFloat = 150
		static let sectionHeight: CGFloat = 30
		static let sectionViewCount: Int = 1
	}

	enum SearchStatus {
		case nothing 	// 첫화면 및 기본
		case searching // 검색 중
		case searched // 검색 완료
	}
}

// MARK: - UISearchBarDelegate

extension MainSearchViewController: UISearchBarDelegate {
	// 검색 버튼 클릭
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		if searchBar.text == "" || searchBar.text == nil { // 검색어가 없을때만
			setDefaultSearchBar()
		} else {
			fetchSearchList(searchBar.text)
		}
	}

	// 취소 버튼 클릭
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.text = ""
		clearData()
	}

	// text Edit Beigin
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		setActiveSearchBar()
		status = .searching
	}

	// text search and save data
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		filteredData.searchedList = searchText.isEmpty ? allRecentData.searchedList : allRecentData.searchedList.filter { data in // 검색
			return data.range(of: searchText, options: .caseInsensitive) != nil
		}
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	// 전체 검색 기록 보여주기
	private func clearData() {
		filteredData.searchedList = allRecentData.searchedList // 전체 검색
		setDefaultSearchBar()
	}

	// 검색 Title이 보이는 기본 화면
	private func setDefaultSearchBar() {
		titleTopConstraint.constant = 0
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		status = .nothing
		searchBar.showsCancelButton = false
		navigationItem.title = nil
		titleLabel.text = Constants.naviTitle
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	// Searching 중인 경우 화면
	private func setActiveSearchBar() {
		titleLabel.text = "" // hiidden의 개념
		titleTopConstraint.constant = -Constants.topTitleMargin
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		searchBar.showsCancelButton = true
	}
}

// MARK: - UIScrollViewDelegate

extension MainSearchViewController {

	/// 스크롤 애니메이션
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if status != .nothing { return } // 첫화면만 animation
		if tableView.contentSize.height < self.tableView.frame.height { return } // vertical scroll 이 안되는 경우
		if titleTopConstraint.constant <= -Constants.topTitleMargin, scrollView.contentOffset.y > Constants.topTitleMargin {
			if navigationItem.title == nil { navigationItem.title = "검색" }
			titleTopConstraint.constant = -Constants.topTitleMargin // titleview가 줄어들거나, 늘어날때
		} else if tableView.contentOffset.y <= 0 { // - 로 되는경우
			self.titleTopConstraint.constant = 0
			if navigationItem.title != nil { navigationItem.title = nil }
		} else {
			titleTopConstraint.constant = -scrollView.contentOffset.y
		}
	}
}