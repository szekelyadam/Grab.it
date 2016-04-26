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

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchDoneSegue" {
            let vc = segue.destinationViewController as! BrowseTableViewController
            print(searchTextField.text!)
            vc.searchFieldText = searchTextField.text!;
        }
    }
 

}
