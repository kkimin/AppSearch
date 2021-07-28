//
//  BaseViewController.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import UIKit

protocol BaseViewDelegate: AnyObject {
	var naviType: NavigationType { get set }
}

class BaseViewController: UIViewController, BaseViewDelegate {
	// MARK: - 변수 선언

	private let NAVVIGATION_HEIGHT: CGFloat = 44 // FIXME

	var naviType: NavigationType = .main {
		didSet {
			setNavigationBar(type: naviType)
		}
	}

	lazy var backhBarItem: UIBarButtonItem = {
		let barItem = UIBarButtonItem(title: "검색", style: .plain, target: nil, action: nil)
		return barItem
	}()

	// MARK: - Outlet 정의

	@IBOutlet weak var baseScrollView: UIScrollView!

	// MARK: - Life Cycle

	deinit {
		#if DEBUG
		print("deinit")
		#endif
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		initNavigationBar()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	/// init Default NavigationBar
	private func initNavigationBar() {
		navigationItem.backBarButtonItem = backhBarItem
	}

	/// set Navigation by type
	private func setNavigationBar(type: NavigationType) {
		switch type {
		case .main:
			navigationItem.rightBarButtonItem = nil
			return
		case .detail:
			self.navigationController?.setNavigationBarHidden(false, animated: true)
			return
		}
	}
}

// MARK: - BaseViewController UITextFieldDelegate

extension BaseViewController: UITextFieldDelegate {
	// MARK: - keyboard return key 눌렀을때 닫히기
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - BaseViewController UIScrollViewDelegate

extension BaseViewController: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.view.endEditing(true)
	}
}
