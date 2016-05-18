//
//  EditAdTableViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 08/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EditAdViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: AutoCompleteTextField!
    @IBOutlet weak var categoryTextField: AutoCompleteTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var ad: Ad?
    var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.text = ad?.title
        self.priceTextField.text = String(ad!.price)
        self.locationTextField.text = ad!.cityName
        self.descriptionTextView.text = ad!.desc
        
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
                        if subJson["_id"].string! == self.ad?.categoryId {
                            self.categoryTextField.text = subJson["name"].string!
                        }
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
                "title": self.nameTextField.text! as AnyObject,
                "description": self.descriptionTextView.text! as AnyObject,
                "price": self.priceTextField.text! as AnyObject,
                "user_id": "0000000198e42f0000000004" as AnyObject,
                "city": self.locationTextField.text! as AnyObject
            ]
            
            Alamofire.request(.PUT, "http://grabit-szekelyadam.rhcloud.com/api/ads/\(ad!.id)", parameters: parameters, encoding: .JSON).responseJSON { response in
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
