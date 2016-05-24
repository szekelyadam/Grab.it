//
//  BrowseTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class BrowseTableViewController: UITableViewController {

    var ads = [Ad]()
    var searchFieldText: String?
    var locationPickerText: String?
    var categoryPicker: String?
    var lowestPrice: Int?
    var highestPrice: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = AppDelegate.sharedAppDelegate().url
        
        var text = ""
        var city = ""
        var category = ""
        var gt = 0
        var lt = 0
        
        if searchFieldText != nil {
            text = searchFieldText!
        }
        
        if locationPickerText != nil {
            city = locationPickerText!
        }
        
        if categoryPicker != nil {
            category = categoryPicker!
        }
        
        if lowestPrice != nil && highestPrice != nil  && (lowestPrice! >= 0 && highestPrice > 0) {
            gt = lowestPrice!
            lt = highestPrice!
        }
        
        Alamofire.request(.GET, url + "/api/ads", parameters: ["text": text, "city": city, "category": category, "gt": gt, "lt": lt]).responseJSON { response in
            switch response.result {
            case .Success:
                self.ads.removeAll()
                if let res = response.result.value {
                    let json = JSON(res)
                    for (_,subJson):(String, JSON) in json {
                        let ad = Ad(id: subJson["_id"].string!, title: subJson["title"].string!, desc: subJson["description"].string!, price: subJson["price"].int!, imageUrl: "", cityId: subJson["city"]["id"].int!, cityName: subJson["city"]["name"].string!, userId: subJson["user_id"].string!, categoryId: subJson["category"]["id"].string!, created: NSDate(), updated: NSDate())
                        if subJson["image_url"] != nil {
                            ad.imageUrl = "\(url)\(subJson["image_url"].string!)"
                        }
                        self.ads.append(ad)
                    }
                }
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
        

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
        return self.ads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AdTableViewCell = tableView.dequeueReusableCellWithIdentifier("BrowseTableViewCell", forIndexPath: indexPath) as! AdTableViewCell
        
        let adData = self.ads[indexPath.row]
        if adData.imageUrl != "" {
            cell.adImageView.kf_setImageWithURL(NSURL(string: "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(adData.id)/image")!)
        }
        cell.adNameLabel.text = adData.title
        cell.adLocationLabel.text = adData.cityName
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
            let ad = self.ads[row!]
            vc.ad = ad
            vc.title = ad.title
        }
    }
 

}
