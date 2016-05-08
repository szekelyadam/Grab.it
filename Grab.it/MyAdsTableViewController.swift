//
//  MyAdsTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 04/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyAdsTableViewController: UITableViewController {
    
    var ads = [Ad]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://grabit-szekelyadam.rhcloud.com"

        Alamofire.request(.GET, url + "/api/ads", parameters: ["user_id": "0000000198e42f0000000004"]).responseJSON { response in
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
                    self.tableView.reloadData()
                }
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
        let cell: AdTableViewCell = tableView.dequeueReusableCellWithIdentifier("MyAdTableViewCell", forIndexPath: indexPath) as! AdTableViewCell
        
        let adData = self.ads[indexPath.row]
        
        cell.adImageView.kf_setImageWithURL(NSURL(string: adData.imageUrl)!)
        cell.adNameLabel.text = adData.title
        cell.adLocationLabel.text = adData.cityName
        cell.adPriceLabel.text = String(adData.price) + "Ft"
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditAdSegue" {
            let vc = segue.destinationViewController as! EditAdTableViewController
            let row = tableView.indexPathForSelectedRow?.row
            let ad = self.ads[row!]
            vc.ad = ad
            vc.title = "Edit \(ad.title)"
        }
    }

}
