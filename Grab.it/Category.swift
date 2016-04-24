//
//  Category.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id: String
    var name: String
    var parentId: String?
    var icon: String
    
    init(id: String, name: String, parentId: String, icon: String) {
        self.id = id
        self.name = name
        self.parentId = parentId
        self.icon = icon
    }
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
