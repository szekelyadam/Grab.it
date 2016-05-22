//
//  SubCategoryTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 24/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class SubCategoryTableViewController: UITableViewController {
    
    var mainCategory: Category?
    var subCategories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = "\(AppDelegate.sharedAppDelegate().url)/api/categories/\(mainCategory!.id)/subcategories"
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    for (_,subJson):(String, JSON) in json {
                        let c = Category(id: subJson["_id"].string!, name: subJson["name"].string!, parentId: subJson["parent_id"].string!, icon: subJson["icon"].string!)
                        self.subCategories.append(c)
                    }
                    self.tableView.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            case .Failure(let error):
                print(error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("SubCategoryTableViewCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        let categoryData = self.subCategories[indexPath.row]
        
        cell.categoryIconLabel.font = UIFont.fontAwesomeOfSize(17)
        cell.categoryIconLabel.text = String.fontAwesomeIconWithCode(categoryData.icon)
        cell.categoryNameLabel.text = categoryData.name
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
