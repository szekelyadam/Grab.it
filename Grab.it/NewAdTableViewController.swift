//
//  NewAdTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 04/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import RETableViewManager
import SwiftyJSON
import Alamofire

class NewAdTableViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager! = nil
    
    var nameField: RETextItem! = nil
    var priceField: RENumberItem! = nil
    var locationField: REPickerItem! = nil
    var categoryField: REPickerItem! = nil
    var descriptionField: RELongTextItem! = nil

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
        self.nameField = RETextItem(title: nil, value: nil, placeholder: "Ad name")
        section1.addItem(nameField)
        
        // Price field
        self.priceField = RENumberItem(title: nil, value: nil, placeholder: "Price")
        section2.addItem(priceField)
        
        // City picker
        let path = NSBundle.mainBundle().pathForResource("Cities", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData!)
        var cities = [String]()
        
        for (_,subJson):(String, JSON) in json {
            cities.append(subJson["name"].string!)
        }
        
        var citiesOptions = [AnyObject]()
        citiesOptions.append(removeDuplicates(cities))
        self.locationField = REPickerItem(title: "Location", value: nil, placeholder: nil, options: citiesOptions)
        section2.addItem(self.locationField)
        
        // Category picker
        var categoryOptions = [AnyObject]()
        var categoryNames = [String]()
        
        Alamofire.request(.GET, "http://grabit-szekelyadam.rhcloud.com/api/categories/subcategories").responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    for (_,subJson):(String, JSON) in json {
                        categoryNames.append(subJson["name"].string!)
                    }
                }
                categoryOptions.append(categoryNames)
                self.categoryField = REPickerItem(title: "Category", value: nil, placeholder: nil, options: categoryOptions)
                section2.addItem(self.categoryField)
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
        
        // Description field
        self.descriptionField = RELongTextItem(title: nil, value: nil, placeholder: nil)
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
        if segue.identifier == "PostAdSegue" {
            segue.destinationViewController as! MyAdsTableViewController
            let parameters = [
                "title": self.nameField.value,
                "description": self.descriptionField.value,
                "price": self.priceField.value,
                "user_id": "0000000198e42f0000000004",
                "category": self.categoryField.value,
                "city": self.locationField.value
            ]
            
            Alamofire.request(.POST, "http://grabit-szekelyadam.rhcloud.com/api/ads", parameters: parameters as? [String : AnyObject], encoding: .JSON).responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    let alertController = UIAlertController(title: "Success", message:"Ad created", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            }
        }

    }

}
