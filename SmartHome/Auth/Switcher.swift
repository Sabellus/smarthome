//
//  Switcher.swift
//  Cheese
//
//  Created by Савелий Вепрев on 15/02/2019.
//  Copyright © 2019 Saveliy Veprev. All rights reserved.
//

import Foundation

import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if UserDefaults.standard.string(forKey: "token") != nil{
            appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: RoomListViewController())
            storage.userInfo.token = UserDefaults.standard.string(forKey: "token")
            storage.userInfo.token_t = "token "+storage.userInfo.token
            storage.userInfo.email = UserDefaults.standard.string(forKey: "email")
        }
        else {
            appDelegate.window?.rootViewController = LoginViewController.storyboardInstance()
        }     
    }
    
}
