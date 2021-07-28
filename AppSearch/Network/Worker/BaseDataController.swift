//
//  BaseDataController.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//
// 공통 처리 할 수 있도록 상속 구조

import Foundation

class BaseDataController: ResponseListenerDelegate {
	weak var baseView: BaseViewDelegate?

	init() {
	}

	deinit {
		#if DEBUG
		print("deinit")
		#endif
	}

	// MARK: - ResponseListenerDelegate
	func onSuccess(data: ResponseData) {	// 통신 성공시
		#if DEBUG
		print(String(data: data.body ?? Data(), encoding: .utf8) ?? "")
		#endif
	}

	func onFail(data: ResponseData) {		// 통신 실패 공통 처리
		#if DEBUG
		showOnFailLog(data)
		#endif
	}

	func showOnFailLog(_ data: ResponseData) {
		#if DEBUG
		let getData = String(data: data.body ?? Data(), encoding: .utf8) ?? ""
		print(getData)
		print("check network error")
		#endif
	}
}
