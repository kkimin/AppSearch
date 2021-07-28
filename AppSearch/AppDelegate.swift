//
//  AppDelegate.swift
//  AppSearch
//
//  Created by 기민주 on 2021/03/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CoreModel")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - App LifeCycle

	/// 앱이 처음 시작될 때
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setNavigationBar()
		return true
	}

	/// 기본 default Navigation Set
	private func setNavigationBar() {
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
		if #available(iOS 13.0, *) {
			UINavigationBar.appearance().backgroundColor = .systemBackground
		} else {
			UINavigationBar.appearance().backgroundColor = .white
		}
	}
}
