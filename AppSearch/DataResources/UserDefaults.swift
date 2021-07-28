//
//  UserDefaults.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import Foundation

extension UserDefaults {
	enum UserDefaultsKeys: String {
		case contentsPath				// 컨텐츠 path(앱내 Assets)
	}

	/// 데이터 접근 path get
	func getContentsPath() -> ContentsPath {
		return ContentsPath(rawValue: string(forKey: UserDefaultsKeys.contentsPath.rawValue) ?? ContentsPath.assets.rawValue) ?? ContentsPath.assets // 처음엔 assets
	}

	/// 데이터 접근 path set
	func setContentsPath(_ path: ContentsPath) {
		set(path.rawValue, forKey: UserDefaultsKeys.contentsPath.rawValue)
	}

	enum ContentsPath: String {
		case assets				// 앱내 저장된 Resources 최초시
		case coreData			// documents directory 사용
	}
}
