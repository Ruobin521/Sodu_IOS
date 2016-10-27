//
//  AppDelegate.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit
import UserNotifications

var  userLogon = false

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
        
        
        userLogon =   checklogon()
        
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
        
        
        guard   let cookie = cookies?.first(where: { (item) -> Bool in
            
            item.name == "sodu_user"
            
        }) else {
            
            return false
        }
        
        
        let tempcookie =   HTTPCookie(properties: [HTTPCookiePropertyKey.name     :  cookie.name ,
                                                   HTTPCookiePropertyKey.value    :  cookie.value ,
                                                   HTTPCookiePropertyKey.domain   :  cookie.domain,
                                                   HTTPCookiePropertyKey.path     :  cookie.path,
                                                   HTTPCookiePropertyKey.version  :  cookie.version,
                                                   HTTPCookiePropertyKey.expires  :  Date(timeIntervalSinceNow: 60*60*24*365*2)
            
            ])
        
        
        HTTPCookieStorage.shared.setCookie(tempcookie!)
        
        return true
    }
    
    
    
    func login() {
        
        
        let url = SoDuUrl.loginPostPage
        
        let postData = "username=918201&userpass=8166450"
        
        
        HttpUtil.instance.request(url: url, requestMethod: .POST, postStr: postData) { (str, isSuccess) in
            
            if str == nil  {
                
                return
                
            }
            
            if (str?.contains("true"))!  && (str?.contains("success"))! {
                
                userLogon = true
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogonSuccessNotification), object: nil)
                
            }
            
        }
    }
    
}

