//
//  Ad.swift
//  Grab.it
//
//  Created by Ádám Székely on 18/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class Ad: NSObject {
    var id: String
    var title: String
    var desc: String
    var price: Int
    var images: [UIImage?]
    var city_id: Int
    var user_id: String
    var category_id: String
    var created: NSDate
    var updated: NSDate
    
    init(id: String, title: String, desc: String, price: Int, images: [UIImage], city_id: Int, user_id: String, category_id: String, created: NSDate, updated: NSDate) {
        self.id = id
        self.title = title
        self.desc = desc
        self.price = price
        self.images = images
        self.city_id = city_id
        self.user_id = user_id
        self.category_id = category_id
        self.created = created
        self.updated = updated
    }
}
