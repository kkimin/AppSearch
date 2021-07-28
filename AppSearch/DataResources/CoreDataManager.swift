//
//  CoreDataManager.swift
//  AppSearch
//
//  Created by Minju Ki on 3/24/21.
//

import UIKit
import CoreData

class CoreDataManager {
	static let shared: CoreDataManager = CoreDataManager()
	private let entityName: String = "RecentRecord"

	/// CoreData record value 저장
	func setRecord(text: String) {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			let context = appDelegate.persistentContainer.viewContext
			if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
				let record = NSManagedObject(entity: entity, insertInto: context)
				record.setValue(text, forKey: "record")

				do {
					try context.save() // 저장
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}

	/// CoreData fetch Record Data
	func fetchRecord() -> SearchedModel.Response? {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			let context = appDelegate.persistentContainer.viewContext
			do {
				if let record = try context.fetch(RecentRecord.fetchRequest()) as? [RecentRecord] {
					var result = SearchedModel.Response()
					result.setSearchedList(data: record)
					return result
				}
			} catch {
				#if DEBUG
				print(error.localizedDescription)
				#endif
			}
		}
		return nil
	}

	/// 기본 데이터를 CoreData로 저장
	func makeDefaultCoreData(data: SearchedModel.Response) {
		UserDefaults.standard.setContentsPath(.coreData)
		deleteAllData(entityName)
		data.searchedList?.forEach({ (value) in
			setRecord(text: value)
		})
	}

	/// 해당 entity에 저장된 데이터 모두 삭제
	func deleteAllData(_ entity: String) {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			let context = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
			fetchRequest.returnsObjectsAsFaults = false
			do {
				let results = try context.fetch(fetchRequest)
				for object in results {
					guard let objectData = object as? NSManagedObject else {continue}
					context.delete(objectData)
				}
			} catch let error {
				#if DEBUG
				print("Detele all data in \(entity) error :", error)
				#endif
			}
		}
	}
}
