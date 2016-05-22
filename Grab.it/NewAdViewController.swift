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

class NewAdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    var imageURL: NSURL? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: AutoCompleteTextField!
    @IBOutlet weak var categoryTextField: AutoCompleteTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var categoryNames = [String]()
    
    @IBAction func changeImageButtonTapped(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
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
        Alamofire.request(.GET, "\(AppDelegate.sharedAppDelegate().url)/api/categories/subcategories").responseJSON { response in
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let localPath = NSURL(fileURLWithPath: documentDirectory).URLByAppendingPathComponent(imageName!)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.0)
        data!.writeToURL(localPath, atomically: true)
        
        print(localPath)
        
        self.imageURL = localPath
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PostAdSegue" {
            segue.destinationViewController as! MyAdsTableViewController
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
            } else {
                let parameters = [
                    "title": self.nameTextField.text! as AnyObject,
                    "description": self.descriptionTextView.text! as AnyObject,
                    "price": self.priceTextField.text! as AnyObject,
                    "user_id": String(NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!) as AnyObject,
                    "category": self.categoryTextField.text! as AnyObject,
                    "city": self.locationTextField.text! as AnyObject
                ]
                
                Alamofire.request(.POST, "\(AppDelegate.sharedAppDelegate().url)/api/ads", parameters: parameters, encoding: .JSON).responseJSON { response in
                    switch response.result {
                    case .Success:
                        if self.imageURL != nil {
                            if let res = response.result.value {
                                let json = JSON(res)
                                print(json["id"].string!)
                                print(self.imageURL!)
                                Alamofire.upload(
                                    .POST,
                                    "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(json["id"].string!)/image",
                                    multipartFormData: { multipartFormData in
                                        multipartFormData.appendBodyPart(fileURL: self.imageURL!, name: "image")
                                    },
                                    encodingCompletion: { encodingResult in
                                        switch encodingResult {
                                        case .Success(let upload, _, _):
                                            upload.responseString { response in
                                                print(response)
                                                let alert = UIAlertController(title: "Ad created", message: "", preferredStyle: .Alert)
                                                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                                                alert.addAction(okAction)
                                                self.presentViewController(alert, animated: true, completion: nil)
                                            }
                                        case .Failure(let encodingError):
                                            print(encodingError)
                                        }
                                    }
                                )
                            }
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        return true
    }

}
