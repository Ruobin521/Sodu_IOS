//
//  AppDelegate.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

var  userLogon = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        

        if  arc4random() % 2  == 0 {
            
          userLogon = true
            
        }
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
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

