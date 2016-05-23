//
//  ProfileViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 08/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.blackColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        let url = "\(AppDelegate.sharedAppDelegate().url)/api/users/\(NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!)"
        
        profileImageView.kf_setImageWithURL(NSURL(string: "\(url)/profile_picture")!)
        
        Alamofire.request(.GET, url, encoding: .JSON).responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    if json["name"] {
                        self.nameLabel.text = json["name"].string!
                    }
                    
                    if json["email"] {
                        self.emailLabel.text = json["email"].string!
                    }
                    
                    if json["phone"] {
                        self.phoneLabel.text = json["phone"].string!
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    @IBAction func updateProfile(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelProfileEdit(segue: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditProfileSegue" {
            let vc = segue.destinationViewController as! EditProfileViewController
            
            vc.name = self.nameLabel.text
            vc.email = self.emailLabel.text
            vc.phone = self.phoneLabel.text
            
        }
    }
 

}
