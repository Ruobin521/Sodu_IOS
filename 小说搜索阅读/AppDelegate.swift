//
//  AppDelegate.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit
import UserNotifications

var  userLogon = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        Thread.sleep(forTimeInterval: 0.5)
        
        
        if #available(iOS 10.0, *) {
         
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound]) { (success, error) in
                
                print("授权" + (success ? "成功"  : "失败"))
            }
        } else {
            
            ///取得用户授权[上方的提示条，声音，badgeNumber]，用户不授权用户是显示不了
            let notifyStting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notifyStting)
            
        }

        
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        

        if  arc4random() % 2  == 0 {
            
          userLogon = true
            
        }
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
        
        UIApplication.shared.isStatusBarHidden = false
        
        return true
    }

   
    //        if userLogon == false  {
    //
    //
    //            let tempAppDelegate = UIApplication.shared.delegate;
    //
    //            let main =     tempAppDelegate!.window!!.rootViewController as! MainViewController ;
    //
    //
    //            let item =  ["clsName": "BookshelfViewController", "title": "个人书架", "imageName" : "profile"]
    //
    //            main.viewControllers?.insert(main.createController(dic: item), at: 0)
    //
    //
    ////            main.reloadInputViews()
    ////
    ////            main.tabBar.reloadInputViews()
    //
    //
    //
    //
    //
    //        }

}

