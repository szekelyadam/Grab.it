//
//  TabBarController.swift
//  Grab.it
//
//  Created by Ádám Székely on 24/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import ChameleonFramework

class TabBarController: UITabBarController {

    @IBOutlet weak var tabs: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        tabs.items![0].image = UIImage.fontAwesomeIconWithName(.Star, textColor: FlatWhite(), size: CGSizeMake(30, 30))
        tabs.items![1].image = UIImage.fontAwesomeIconWithName(.Comment, textColor: FlatWhite(), size: CGSizeMake(30, 30))
        tabs.items![2].image = UIImage.fontAwesomeIconWithName(.Tag, textColor: FlatWhite(), size: CGSizeMake(30, 30))
        tabs.items![3].image = UIImage.fontAwesomeIconWithName(.User, textColor: FlatWhite(), size: CGSizeMake(30, 30))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
