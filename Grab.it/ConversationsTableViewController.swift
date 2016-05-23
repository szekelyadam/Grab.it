//
//  ConversationsTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 23/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class ConversationsTableViewController: UITableViewController {
    
    var conversations = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = AppDelegate.sharedAppDelegate().url
        
        Alamofire.request(.GET, "\(url)/api/users/\(NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!)/conversations").responseJSON { response in
            switch response.result {
            case .Success:
                self.conversations.removeAll()
                if let res = response.result.value {
                    print(res)
                    let json = JSON(res)
                    print(json)
                    for (_,subJson):(String, JSON) in json {
                        if subJson["receiver"]["_id"].string! != NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")! as! String {
                            let c = Conversation(id: subJson["_id"].string!, opponentID: subJson["receiver"]["_id"].string!, opponentName: subJson["receiver"]["name"].string!, updated: NSDate())
                            self.conversations.append(c)
                        } else if subJson["sender"]["_id"] {
                            let c = Conversation(id: subJson["_id"].string!, opponentID: subJson["sender"]["_id"].string!, opponentName: subJson["sender"]["name"].string!, updated: NSDate())
                            self.conversations.append(c)
                        }
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
        return self.conversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ConversationTableViewCell = tableView.dequeueReusableCellWithIdentifier("ConversationTableViewCell", forIndexPath: indexPath) as! ConversationTableViewCell
        
        let convData = self.conversations[indexPath.row]
        
        cell.opponentNameLabel.text = convData.opponentName
        cell.convDateLabel.text = String(convData.updated)
        
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
        if segue.identifier == "ShowConversationSegue" {
            let vc = segue.destinationViewController as! ConversationViewController
            let row = tableView.indexPathForSelectedRow?.row
            let conv = self.conversations[row!]
            vc.conversationId = conv.id
            vc.receiverId = conv.opponentID
            
        }
    }
    
    
}
