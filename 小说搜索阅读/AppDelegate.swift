//
//  AppDelegate.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 0.5)
        
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound]) { (success, error) in
                
                print("通知授权" + (success ? "成功"  : "失败"))
            }
        } else {
            
            ///取得用户授权[上方的提示条，声音，badgeNumber]，用户不授权用户是显示不了
            let notifyStting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notifyStting)
            
        }
        
       // var manager =   SoDuSQLiteManager.shared
        
        ViewModelInstance.instance.userLogon =   checklogon()
        
       // userLogon =  false
        
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
        
        UIApplication.shared.isStatusBarHidden = false
        
        return true
    }
    
    
}


extension AppDelegate {
    
    func checklogon() -> Bool {
        
        let cookies =   HTTPCookieStorage.shared.cookies(for:  URL.init(string: SoDuUrl.homePage)!)
        
        
        guard   let _ = cookies?.first(where: { (item) -> Bool in
            
            item.name == "sodu_user"
            
        }) else {
            
            return false
        }
        
        
        return true
    }
    
    
    
    
}

