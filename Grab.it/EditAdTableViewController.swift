//
//  EditAdTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 08/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import RETableViewManager
import SwiftyJSON
import Alamofire

class EditAdTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager! = nil
    
    var nameField: RETextItem! = nil
    var priceField: RENumberItem! = nil
    var locationField: REPickerItem! = nil
    var descriptionField: RELongTextItem! = nil
    
    var ad: Ad?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up manager
        self.manager = RETableViewManager(tableView: self.tableView)
        self.manager.delegate = self
        
        // Create sections
        let section1: RETableViewSection = RETableViewSection(headerTitle: "Name")
        let section2: RETableViewSection = RETableViewSection(headerTitle: "Price")
        let section3: RETableViewSection = RETableViewSection(headerTitle: "Description")
        self.manager.addSection(section1)
        self.manager.addSection(section2)
        self.manager.addSection(section3)
        
        // Name field
        self.nameField = RETextItem(title: nil, value: ad?.title, placeholder: "Ad name")
        section1.addItem(nameField)
        
        // Price field
        self.priceField = RENumberItem(title: nil, value: String(ad!.price), placeholder: "Price")
        section2.addItem(priceField)
        
        // City picker
        let path = NSBundle.mainBundle().pathForResource("Cities", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData!)
        var cities = [String]()
        
        for (_,subJson):(String, JSON) in json {
            cities.append(subJson["name"].string!)
        }
        
        var valueArray = [AnyObject]()
        valueArray.append(ad!.cityName as AnyObject)
        
        var citiesOptions = [AnyObject]()
        citiesOptions.append(removeDuplicates(cities))
        self.locationField = REPickerItem(title: "Location", value: valueArray, placeholder: nil, options: citiesOptions)
        section2.addItem(self.locationField)
        
        // Description field
        self.descriptionField = RELongTextItem(title: nil, value: ad!.desc, placeholder: nil)
        self.descriptionField.cellHeight = CGFloat(100)
        section3.addItem(descriptionField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UpdateAdSegue" {
            segue.destinationViewController as! MyAdsTableViewController
            let parameters = [
                "title": self.nameField.value,
                "description": self.descriptionField.value,
                "price": self.priceField.value,
                "user_id": "0000000198e42f0000000004",
                "city": self.locationField.value
            ]
            
            Alamofire.request(.PUT, "http://grabit-szekelyadam.rhcloud.com/api/ads/\(ad!.id)", parameters: parameters as? [String : AnyObject], encoding: .JSON).responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    let alertController = UIAlertController(title: "Success", message:"Ad updated", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
 

}
