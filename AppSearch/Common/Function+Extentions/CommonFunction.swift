//
//  CommonFunction.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import UIKit

// MARK: - Keywindow 반환
func getKeyWindow() -> UIWindow? {
	var window: UIWindow?
	if #available(iOS 13.0, *) {
		window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
	} else {
		window = UIApplication.shared.keyWindow
	}
	return window
}

// MARK: - Top SafeAreaInsets을 반환하는 함수
/// Top SafeAreaInsets을 반환하는 함수
func getTopSafeAreaInsets() -> CGFloat {
	let topSafeArea: CGFloat = getKeyWindow()?.safeAreaInsets.top ?? 0 // iOS 11 이상에서만 값을 가져온다.
	return topSafeArea == 0 ? UIApplication.shared.statusBarFrame.height : topSafeArea
}

// MARK: - ViewController를 찾아주는 함수
/**
Storyboard에 설정한 identifier로 UIViewController를 찾아주는 함수
- Parameter storyboardName: 스토리보드 이름
- Parameter identifier: viewController id
- Returns: Optional(UIViewController)
*/
func getViewController(storyboardName: String, identifier: String) -> UIViewController? {
	let storyBoard: UIStoryboard! = UIStoryboard(name: storyboardName, bundle: nil)
	return storyBoard.instantiateViewController(withIdentifier: identifier)
}
