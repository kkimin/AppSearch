//
//  MainSearchWorker.swift
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

typealias DataCompletion = ((InquiryModel?) -> Void)

class MainSearchWorker: BaseDataController {

	var model: InquiryModel? {
		didSet {
			datacompletion?(model)
		}
	}

	var datacompletion: DataCompletion?

	func doSearch(request: MainSearch.Request, completion: @escaping (InquiryModel?) -> Void) {
		let searchParam = NetworkParam(detailURL: "/search", parameters: ["term": request.searchText, "country": "KR"], responseListener: self)
		let networkService = NetworkWorker.init()
		networkService.requestGet(param: searchParam)
		datacompletion = completion
	}

	// MARK: - 통신 결과

	override func onSuccess(data: ResponseData) {
		// loading hide
		DispatchQueue.main.async {
			if let data = data.body {
				do {
					let resultData = try JSONDecoder().decode(InquiryModel.self, from: data)
					self.model = resultData
				} catch {
					#if DEBUG
					print("DECODE FAIL" + error.localizedDescription)
					#endif
				}
			}
		}
	}

	override func onFail(data: ResponseData) {
		datacompletion?(nil)
	}
}