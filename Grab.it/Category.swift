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
    var parent_id: String
    var icon: UIImage?
    
    init(id: String, name: String, parent_id: String, icon: UIImage) {
        self.id = id
        self.name = name
        self.parent_id = parent_id
        self.icon = icon
    }
}
