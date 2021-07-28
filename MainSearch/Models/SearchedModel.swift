//
//  SearchedModel.swift
//  AppSearch
//
//  Created by Minju Ki on 3/23/21.
//

import Foundation

enum SearchedModel {
	// MARK: - Use cases

	struct Response: Decodable {
		var searchedList: [String]?

		private enum CodingKeys: String, CodingKey {
			case searchedList
		}

		init() {
			searchedList = [""]
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.searchedList = try container.decodeIfPresent([String].self, forKey: .searchedList) ?? []
		}

		mutating func setSearchedList(data: [RecentRecord]) {
			searchedList = data.map { ($0.record ?? "") }
		}
	}

	struct ViewModel {
		var searchedList: [String]
	}
}
