//
//  TableBGColour.swift
//  TodoList
//
//  Created by Алесь Шеншин on 18/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import Foundation
import RealmSwift

protocol TableBGColour {
    var colour: String {get set}
}

class Table: Object, TableBGColour {
    @objc dynamic var colour: String = ""
}
