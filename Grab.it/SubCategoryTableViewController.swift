//
//  SubCategoryTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 24/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit

class SubCategoryTableViewController: UITableViewController {
    
    var dataManager: DataManager?
    var mainCategory: Category?
    var subCategories: [Category]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = AppDelegate.sharedAppDelegate().dataManager
        subCategories = [Category]()
        
        for category in dataManager!.subCategories {
            if category.parentId == mainCategory!.id {
                subCategories?.append(category)
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
        return subCategories!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("SubCategoryTableViewCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        let categoryData = subCategories![indexPath.row] as Category
        
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
