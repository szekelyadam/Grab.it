//
//  SearchViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 26/04/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RETableViewManager

class SearchViewController: UITableViewController, RETableViewManagerDelegate {
    
    var manager: RETableViewManager! = nil
    
    var searchField: RETextItem! = nil
    var locationField: REPickerItem! = nil
    var categoryField: REPickerItem! = nil
    var priceRangeField: REPickerItem! = nil
    
    var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = RETableViewManager(tableView: self.tableView)
        self.manager.delegate = self
        
        let section1: RETableViewSection = RETableViewSection(headerTitle: "")
        self.manager.addSection(section1)
        
        self.searchField = RETextItem(title: nil, value: nil, placeholder: "Search in title or description")
        section1.addItem(searchField)
        
        let section2: RETableViewSection = RETableViewSection(headerTitle: "")
        self.manager.addSection(section2)
        
        self.locationField = REPickerItem(title: "Location", value: nil, placeholder: nil, options: [["Budapest", "Békéscsaba"]])
        section2.addItem(self.locationField)
        
        var lowerPrice = [String]()
        var higherPrice = [String]()
        
        var num = 0
        while num <= 10000000 {
            lowerPrice.append(String(num))
            higherPrice.append(String(num))
            num += 1000
        }
        
        var priceOptions = [AnyObject]()
        priceOptions.append(lowerPrice)
        priceOptions.append(higherPrice)
        
        self.priceRangeField = REPickerItem(title: "Price range", value: ["0", "0"], placeholder: nil, options: priceOptions)
        section2.addItem(self.priceRangeField)
        
        var categoryOptions = [AnyObject]()
        
        Alamofire.request(.GET, "http://grabit-szekelyadam.rhcloud.com/api/categories/subcategories").responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    for (_,subJson):(String, JSON) in json {
                        self.categoryNames.append(subJson["name"].string!)
                    }
                }
                categoryOptions.append(self.categoryNames)
                self.categoryField = REPickerItem(title: "Category", value: nil, placeholder: nil, options: categoryOptions)
                section2.addItem(self.categoryField)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchDoneSegue" {
//            let vc = segue.destinationViewController as! BrowseTableViewController
//            print(searchTextField.text!)
//            vc.searchFieldText = searchTextField.text!;
        }
    }
 

}
