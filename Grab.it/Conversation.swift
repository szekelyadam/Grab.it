//
//  Conversation.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class Conversation: NSObject {
    var id: String
    var opponentID: String
    var updated: NSDate
    var opponentName: String
    
    init(id: String, opponentID: String, opponentName: String, updated: NSDate) {
        self.id = id
        self.opponentID = opponentID
        self.updated = updated
        self.opponentName = opponentName
    }

}
