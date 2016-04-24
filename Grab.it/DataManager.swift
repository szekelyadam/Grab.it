//
//  DataManager.swift
//  Grab.it
//
//  Created by Ádám Székely on 24/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    var ads: [Ad]
    var counties: [County]
    var cities: [City]
    var mainCategories: [Category]
    var subCategories: [Category]
    
    override init() {
        let a1 = Ad(id: "1", title: "MacBook Air", desc: "Used MacBook Air in perfect condition", price: 299900, imageUrl: "https://cnet3.cbsistatic.com/hub/i/r/2012/06/14/e9ea663a-0541-11e3-bf02-d4ae52e62bcc/thumbnail/770x433/bef0d642f4d9f093d46c2de3425154b2/MacBook_Air_13-inch_35330106_01.jpg", cityId: 1, userId: "1", categoryId: "1", created: NSDate(), updated: NSDate())
        let a2 = Ad(id: "2", title: "iPhone 5S", desc: "Used iPhone 5S in excellent condition", price: 70000, imageUrl: "https://cnet4.cbsistatic.com/hub/i/r/2013/09/12/61c8a38d-67c2-11e3-a665-14feb5ca9861/thumbnail/770x433/5b4b87f7a4fc4c5133d1329384940927/Septimius_14.jpg", cityId: 2, userId: "2", categoryId: "2", created: NSDate(), updated: NSDate())
        
        ads = [Ad]()
        ads.append(a1)
        ads.append(a2)
        
        let co1 = County(id: 1, name: "Budapest")
        let co2 = County(id: 2, name: "Békés")
        
        counties = [County]()
        counties.append(co1)
        counties.append(co2)
        
        let ci1 = City(id: 1, countyId: 1, zip: 1076, name: "Budapest")
        let ci2 = City(id: 2, countyId: 2, zip: 5600, name: "Békéscsaba")
        
        cities = [City]()
        cities.append(ci1)
        cities.append(ci2)
        
        let ca1 = Category(id: "1", name: "Electronics", icon: "fa-desktop")
        let ca2 = Category(id: "2", name: "Motors", icon: "fa-automobile")
        let ca3 = Category(id: "3", name: "Laptops", parentId: "1", icon: "fa-laptop")
        let ca4 = Category(id: "4", name: "Smart phones", parentId: "1", icon: "fa-mobile")
        let ca5 = Category(id: "5", name: "Cars", parentId: "2", icon: "fa-automobile")
        let ca6 = Category(id: "6", name: "Motorcycles", parentId: "2", icon: "fa-motorcycle")
        
        mainCategories = [Category]()
        subCategories = [Category]()
        mainCategories.append(ca1)
        mainCategories.append(ca2)
        subCategories.append(ca3)
        subCategories.append(ca4)
        subCategories.append(ca5)
        subCategories.append(ca6)
        
    }
}
