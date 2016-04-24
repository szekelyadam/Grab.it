//
//  BrowseTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Kingfisher

class BrowseTableViewController: UITableViewController {

    var dataManager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = AppDelegate.sharedAppDelegate().dataManager
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager!.ads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AdTableViewCell = tableView.dequeueReusableCellWithIdentifier("BrowseTableViewCell", forIndexPath: indexPath) as! AdTableViewCell
        
        let adData = dataManager!.ads[indexPath.row] as Ad
        
        cell.adImageView.kf_setImageWithURL(NSURL(string: adData.imageUrl)!)
        cell.adNameLabel.text = adData.title
        cell.adLocationLabel.text = adData.getCityName()
        cell.adPriceLabel.text = String(adData.price) + "Ft"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AdDetailsSegue" {
            let vc = segue.destinationViewController as! AdViewController
            let row = tableView.indexPathForSelectedRow?.row
            let ad = dataManager!.ads[row!] as Ad
            vc.ad = ad
            vc.title = ad.title
        }
    }
 

}
