//
//  Item.swift
//  TodoList
//
//  Created by Алесь Шеншин on 15/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: RealmCategory.self, property: "items")
}
