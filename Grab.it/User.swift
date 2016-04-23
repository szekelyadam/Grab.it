//
//  User.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String
    var name: String
    var email: String
    var phone: String
    var city: String
    var address: String
    var zip: Int
    var saved_ads: [Ad]
    var image: UIImage?
    
    init(id: String, name: String, email: String, phone: String, city: String, address: String, zip: Int, saved_ads: [Ad], image: UIImage) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.city = city
        self.address = address
        self.zip = zip
        self.saved_ads = saved_ads
        self.image = image
    }
}
