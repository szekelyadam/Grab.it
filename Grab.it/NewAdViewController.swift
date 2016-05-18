//
//  NewAdTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 04/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NewAdViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: AutoCompleteTextField!
    @IBOutlet weak var categoryTextField: AutoCompleteTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
        
        self.locationTextField.autoCompleteStrings = cities
        
        self.locationTextField.onTextChange = {[weak self] text in
            let filtered = cities.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercaseString.rangeOfString(text.lowercaseString)
                return stringMatch != nil ? true : false
            })
            
            self!.locationTextField.autoCompleteStrings = filtered
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
        if segue.identifier == "PostAdSegue" {
            segue.destinationViewController as! MyAdsTableViewController
            let parameters = [
                "title": self.nameTextField.text! as AnyObject,
                "description": self.descriptionTextView.text! as AnyObject,
                "price": self.priceTextField.text! as AnyObject,
                "user_id": "0000000198e42f0000000004" as AnyObject,
                "category": self.categoryTextField.text! as AnyObject,
                "city": self.locationTextField.text! as AnyObject
            ]
            
            Alamofire.request(.POST, "http://grabit-szekelyadam.rhcloud.com/api/ads", parameters: parameters, encoding: .JSON).responseJSON { response in
                switch response.result {
                case .Success:
                    print(response)
                    let alertController = UIAlertController(title: "Success", message:"Ad created", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            }
        }

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "PostAdSegue" {
            if (nameTextField.text == nil || priceTextField.text == nil || locationTextField.text == nil || categoryTextField.text == nil || descriptionTextView.text == nil) {
                
                let alert = UIAlertController(title: "Ad cannot be created", message: "Please fill all the missing fields", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
                
            else {
                return true
            }
        }
        
        return true
    }

}
