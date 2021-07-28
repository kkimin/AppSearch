//
//  BaseNavigationController.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import UIKit

enum NavigationType {
	case main
	case detail
}

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {

	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	// MARK: - life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self // pop gesture
	}
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}
