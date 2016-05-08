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

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(.GET, "http://grabit-szekelyadam.rhcloud.com/api/users/\(NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!)", encoding: .JSON).responseJSON { response in
            switch response.result {
            case .Success:
                if let res = response.result.value {
                    let json = JSON(res)
                    self.nameLabel.text = json["name"].string!
                    self.emailLabel.text = json["email"].string!
                    self.phoneLabel.text = json["phone"].string!
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
