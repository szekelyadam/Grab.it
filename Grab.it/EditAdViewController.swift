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
import Kingfisher

class EditAdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: AutoCompleteTextField!
    @IBOutlet weak var categoryTextField: AutoCompleteTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var adImageView: UIImageView!
    
    var ad: Ad?
    var categoryNames = [String]()
    var imageURL: NSURL? = nil
    
    @IBAction func changeAdImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.text = ad?.title
        self.priceTextField.text = String(ad!.price)
        self.locationTextField.text = ad!.cityName
        self.descriptionTextView.text = ad!.desc
        
        self.imagePicker.delegate = self
        
        self.adImageView.kf_setImageWithURL(NSURL(string: "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(ad!.id)/image")!)
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let localPath = NSURL(fileURLWithPath: documentDirectory).URLByAppendingPathComponent(imageName!)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.0)
        data!.writeToURL(localPath, atomically: true)
        
        self.imageURL = localPath
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        adImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UpdateAdSegue" {
            segue.destinationViewController as! MyAdsTableViewController
        } else if segue.identifier == "DeleteAdSegue" {
            let vc = segue.destinationViewController as! MyAdsTableViewController
            
            Alamofire.request(.DELETE, "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(ad!.id)", encoding: .JSON).responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    while vc.ads.contains(self.ad!) {
                        if let itemToRemoveIndex = vc.ads.indexOf(self.ad!) {
                            vc.ads.removeAtIndex(itemToRemoveIndex)
                        }
                    }
                    
                    let alertController = UIAlertController(title: "Success", message:"Ad deleted", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "UpdateAdSegue" {
            let parameters = [
                "title": self.nameTextField.text! as AnyObject,
                "description": self.descriptionTextView.text! as AnyObject,
                "price": self.priceTextField.text! as AnyObject,
                "user_id": NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")! as AnyObject,
                "city": self.locationTextField.text! as AnyObject
            ]
            
            let url = "\(AppDelegate.sharedAppDelegate().url)/api/ads/\(ad!.id)"
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .JSON).responseJSON { response in
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
            
            if self.imageURL != nil {
                Alamofire.upload(
                    .POST,
                    "\(url)/image",
                    multipartFormData: { multipartFormData in
                        multipartFormData.appendBodyPart(fileURL: self.imageURL!, name: "image")
                    },
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseString { response in
                                print(response)
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                    }
                )
                return true
            } else {
                return true
            }

        } else {
            return true
        }
    }
}
