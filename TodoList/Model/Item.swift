//
//  Item.swift
//  TodoList
//
//  Created by Алесь Шеншин on 12/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var done: Bool
    init(title: String, done: Bool){
        self.title = title
        self.done = done
    }
    init(){
        self.title = ""
        self.done = false
    }
}
