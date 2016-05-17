//
//  SearchViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 18/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityTextField: AutoCompleteTextField!
    @IBOutlet weak var categoryTextField: AutoCompleteTextField!
    @IBOutlet weak var minimumPriceTextField: UITextField!
    @IBOutlet weak var maximumPriceTextField: UITextField!
    
    var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cities autocomplete text field
        let path = NSBundle.mainBundle().pathForResource("Cities", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData!)
        var cities = [String]()
        
        for (_,subJson):(String, JSON) in json {
            cities.append(subJson["name"].string!)
        }
        
        cities = removeDuplicates(cities)
        
        self.cityTextField.autoCompleteStrings = cities
        
        self.cityTextField.onTextChange = {[weak self] text in
            let filtered = cities.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercaseString.rangeOfString(text.lowercaseString)
                return stringMatch != nil ? true : false
            })
            
            self!.cityTextField.autoCompleteStrings = filtered
        }
        
        // Categories autocomplete text field
        Alamofire.request(.GET, "http://grabit-szekelyadam.rhcloud.com/api/categories/subcategories").responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    for (_,subJson):(String, JSON) in json {
                        self.categoryNames.append(subJson["name"].string!)
                    }
                }
                self.categoryTextField.autoCompleteStrings = self.categoryNames
            case .Failure(let error):
                print(error)
            }
        }
        
        self.categoryTextField.onTextChange = {[weak self] text in
            let filtered = self?.categoryNames.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercaseString.rangeOfString(text.lowercaseString)
                return stringMatch != nil ? true : false
            })
            
            self!.categoryTextField.autoCompleteStrings = filtered
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchDoneSegue" {
            let vc = segue.destinationViewController as! BrowseTableViewController
            if self.searchTextField.text != nil {
                vc.searchFieldText = self.searchTextField.text!;
            }
            
            if self.cityTextField.text != nil {
                vc.locationPickerText = self.cityTextField.text!
            }
            
            if self.categoryTextField.text != nil {
                vc.categoryPicker = self.categoryTextField.text!
            }
            
            if self.minimumPriceTextField.text != nil {
                vc.lowestPrice = Int(self.minimumPriceTextField.text!)
            }
            
            if self.maximumPriceTextField.text != nil {
                vc.highestPrice = Int(self.maximumPriceTextField.text!)
            }
        }
    }
    

}

func removeDuplicates(array: [String]) -> [String] {
    var encountered = Set<String>()
    var result: [String] = []
    for value in array {
        if encountered.contains(value) {
            // Do not add a duplicate element.
        }
        else {
            // Add value to the set.
            encountered.insert(value)
            // ... Append the value.
            result.append(value)
        }
    }
    return result
}
