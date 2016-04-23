//
//  City.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class City: NSObject {
    var id: Int
    var county_id: Int
    var zip: Int
    var name: String
    
    init(id: Int, county_id: Int, zip: Int, name: String) {
        self.id = id
        self.county_id = county_id
        self.zip = zip
        self.name = name
    }
}
