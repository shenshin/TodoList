//
//  AppDelegate.swift
//  TodoList
//
//  Created by Алесь Шеншин on 09/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
            //print(Realm.Configuration.defaultConfiguration.fileURL ?? "Не могу найти файл базы данных")
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return true
    }
}
