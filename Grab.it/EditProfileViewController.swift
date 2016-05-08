//
//  EditProfileViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 08/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var name: String? = nil
    var email: String? = nil
    var phone: String? = nil

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBAction func changeProfilePictureButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView.layer.borderWidth = 1
        profilePictureImageView.layer.masksToBounds = false
        profilePictureImageView.layer.borderColor = UIColor.blackColor().CGColor
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
        
        imagePicker.delegate = self
        
        if self.name != nil {
            self.nameTextField.text = self.name
        }
        
        if self.email != nil {
            self.emailTextField.text = self.email
        }
        
        if self.phone != nil {
            self.phoneTextField.text = self.phone
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UpdateProfileSegue" {
            segue.destinationViewController as! ProfileViewController
            
            var image = String()
            
            if self.profilePictureImageView.image != nil {
                if let jpegImageData = UIImageJPEGRepresentation(self.profilePictureImageView.image!, 1.0) {
                    image = jpegImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
                }
            }
            
            let parameters : [String : AnyObject] = [
                "name": nameTextField.text!,
                "email": emailTextField.text!,
                "phone": phoneTextField.text!,
                "image": image
            ]
            
            let url = "http://grabit-szekelyadam.rhcloud.com/api/users/\(NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!)"
            
            Alamofire.request(.PUT, url, parameters: parameters as [String : AnyObject], encoding: .JSON).responseString { response in
                print(response)
                switch response.result {
                case .Success:
                    let alertController = UIAlertController(title: "Success", message:"Profile data updated", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            }
            
        }
    }
    

}
