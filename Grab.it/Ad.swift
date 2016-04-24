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
    var imageUrl: String
    var cityId: Int
    var userId: String
    var categoryId: String
    var created: NSDate
    var updated: NSDate
    
    init(id: String, title: String, desc: String, price: Int, imageUrl: String, cityId: Int, userId: String, categoryId: String, created: NSDate, updated: NSDate) {
        self.id = id
        self.title = title
        self.desc = desc
        self.price = price
        self.imageUrl = imageUrl
        self.cityId = cityId
        self.userId = userId
        self.categoryId = categoryId
        self.created = created
        self.updated = updated
    }
    
    func getCityName() -> String {
        for city in AppDelegate.sharedAppDelegate().dataManager.cities {
            if city.id == self.cityId {
                return city.name
            }
        }
        return ""
    }
    
    func getFormattedCreationDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.stringFromDate(self.created)
    }
}
