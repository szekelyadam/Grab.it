//
//  ConversationViewController.swift
//  Grab.it
//
//  Created by Ádám Székely on 22/05/16.
//  Copyright © 2016 Ádám Székely. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import Alamofire
import SwiftyJSON

class ConversationViewController: UIViewController, LGChatControllerDelegate {
    
    var receiverId: String = ""
    var conversationId: String = ""
    var messages = [LGChatMessage]()
    let chatController = LGChatController()
    var socket = SocketIOClient(socketURL: NSURL(string: AppDelegate.sharedAppDelegate().url)!, options: [.Log(true)])

    override func viewDidLoad() {
        super.viewDidLoad()
        launchChatController()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        socket.on("connect") {data, ack in
            print("socket connected")
            self.socket.emit("register", NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!)
        }
        
        socket.on("message") {data, ack in
            if (data[0]["to"]! as! String) == NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")! as! String {
                let msg = LGChatMessage(content: data[0]["msg"]! as! String, sentBy: .Opponent)
                self.chatController.addNewMessage(msg)
            }
        }
        
        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchChatController() {
        if self.conversationId != "" {
            print("\(AppDelegate.sharedAppDelegate().url)/api/conversations/\(self.conversationId)/messages")
            Alamofire.request(.GET, "\(AppDelegate.sharedAppDelegate().url)/api/conversations/\(self.conversationId)/messages").responseJSON { response in
                switch response.result {
                case .Success:
                    if let res = response.result.value {
                        print(res)
                        let json = JSON(res)
                        print(json)
                        for (_,subJson):(String, JSON) in json {
                            if subJson["sender_id"].string! == NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")! as! String {
                                let msg = LGChatMessage(content: subJson["message"].string!, sentBy: .User)
                                self.messages.append(msg)
                            } else {
                                let msg = LGChatMessage(content: subJson["message"].string!, sentBy: .Opponent)
                                self.messages.append(msg)
                            }
                        }
                        self.chatController.messages = self.messages
                        self.chatController.delegate = self
                        self.navigationController?.pushViewController(self.chatController, animated: false)
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        } else {
            chatController.messages = [LGChatMessage]()
            chatController.delegate = self
            self.navigationController?.pushViewController(chatController, animated: false)
        }
    }
    
    func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
        print("Did Add Message: \(message.content)")
        // self.messages.append(message)
        socket.emit("message", [NSUserDefaults.standardUserDefaults().objectForKey("UserUUID")!, receiverId, message.content])
    }
    
    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        /*
         Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
         */
        return true
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
