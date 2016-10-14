//
//  AppDelegate.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = MainViewController()
        
        
        window?.makeKeyAndVisible()
       
        
        
        
        return true
    }

   

}

