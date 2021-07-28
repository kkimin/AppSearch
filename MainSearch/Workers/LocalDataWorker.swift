//
//  LocalDataWorker.swift
//  AppSearch
//
//  Created by Minju Ki on 3/23/21.
//

import Foundation
import CoreData

class LocalDataWorker {

	let coreManager = CoreDataManager()

	/// 저장되어있는 최근검색어 데이터 가져오는 함수
	func getData(completion: @escaping (SearchedModel.Response) -> Void) {
		switch UserDefaults.standard.getContentsPath() {
		case .assets:
		if let contentsData = getJsonDataFromBundle() {
			completion(contentsData)
		}
		case .coreData:
			if let contentsData = coreManager.fetchRecord() {
				completion(contentsData)
			}
		}
	}

	// get 저장된 Json Data
	private func getJsonDataFromBundle() -> SearchedModel.Response? {
		guard let path = Bundle.main.path(forResource: "searchedList", ofType: "json") else { return nil }
		do {
			let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			let resultData = try JSONDecoder().decode(SearchedModel.Response.self, from: jsonData)
			coreManager.makeDefaultCoreData(data: resultData)
			return resultData
		} catch {
			#if DEBUG
			print("searchedList json Decode Fail")
			#endif
		}
		return nil
	}

	// CoreData Record 추가
	func setRecordCoreData(addData: String) {
		coreManager.setRecord(text: addData)
	}
}
