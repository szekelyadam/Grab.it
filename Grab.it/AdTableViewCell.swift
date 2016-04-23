//
//  AdTableViewCell.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class AdTableViewCell: UITableViewCell {

    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adNameLabel: UILabel!
    @IBOutlet weak var adLocationLabel: UILabel!
    @IBOutlet weak var adPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
