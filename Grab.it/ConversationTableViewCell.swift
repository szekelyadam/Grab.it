//
//  ConversationTableViewCell.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var convDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
