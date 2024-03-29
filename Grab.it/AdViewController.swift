//
//  AdViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 24/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Kingfisher

class AdViewController: UIViewController {

    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adNameLabel: UILabel!
    @IBOutlet weak var adPostedDateLabel: UILabel!
    @IBOutlet weak var adLocationLabel: UILabel!
    @IBOutlet weak var adPriceLabel: UILabel!
    @IBOutlet weak var adDetailsTextView: UITextView!
    
    var ad: Ad?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ad != nil {
            adImageView.kf_setImageWithURL(NSURL(string: "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(ad!.id)/image")!)
            adNameLabel.text = ad!.title
            adPostedDateLabel.text = ad!.getFormattedCreationDate()
            adLocationLabel.text = ad!.cityName
            adPriceLabel.text = String(ad!.price) + "Ft"
            adDetailsTextView.text = ad!.desc
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartConversationSegue" {
            let vc = segue.destinationViewController as! ConversationViewController
            vc.receiverId = ad!.userId
        }
    }
 

}
