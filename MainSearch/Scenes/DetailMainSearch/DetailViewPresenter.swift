//
//  DetailViewPresenter.swift
//  AppSearch
//
//  Created by Minju Ki on 3/25/21.
//

import Foundation

protocol DetailPresentationLogic {
	func presentTestData(model: MainSearch.ViewModel)
}

class DetailViewPresenter: DetailPresentationLogic {
	weak var viewController: DetailViewDisplayLogic?

	// TestData Present To ViewController
	func presentTestData(model: MainSearch.ViewModel) {
		if let testData = model.testData {
			viewController?.displayTestData(viewModel: testData)
		}
	}
}
