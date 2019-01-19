//
//  Category.swift
//  TodoList
//
//  Created by Алесь Шеншин on 15/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Table {
    @objc dynamic var name: String = ""
    let items = List<RealmItem>()
}
