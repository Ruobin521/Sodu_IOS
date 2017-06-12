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
        
        Thread.sleep(forTimeInterval: 1)
        
        
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
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        application.setMinimumBackgroundFetchInterval(10800)
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if  UserDefaultsHelper.getStringValue(key: .UserNameKey) ==  nil {
            
            return
        }
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        
        
        if( (comps.hour! > 0 && comps.hour! < 7) || comps.hour! > 22) {
            return
        }
        
        
        if checkBookShelfData()  {
            
          
            //清除所有本地推送
            UIApplication.shared.cancelAllLocalNotifications()
            //创建UILocalNotification来进行本地消息通知
            let localNotification = UILocalNotification()
            
        
            //推送时间（立刻推送）
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
            //时区
            localNotification.timeZone = NSTimeZone.default
            //推送内容
            localNotification.alertBody = "在线书架有更新啦，别忘了追更哦。"
            //声音
            localNotification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
            
            //让OS知道已经获取到新数据
            completionHandler(UIBackgroundFetchResult.newData)
            
        }
        
    }
    
}


extension AppDelegate {
    
    
    func checkBookShelfData() -> Bool {
        
        var result:Bool  = false
        
        let userId =  UserDefaultsHelper.getStringValue(key: .UserNameKey)
        //创建NSURL对象
        let url:URL! = URL(string: SoDuUrl.bookShelfPage)
        //创建请求对象
        var urlRequest:URLRequest = URLRequest(url: url)
        //响应对象
        var response:URLResponse?
        
        urlRequest.timeoutInterval = 25
        
        do {
            
            if  let data:Data =  try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: &response) as Data? {
                
                guard  let  str = String(data: data , encoding: .utf8) else {
                    
                    return false
                }
                
                let list =  AnalisysBookListHtmlHelper.analisysBookShelfHtml(str)
                
                let localbooks =  SoDuSQLiteManager.shared.selectBook(tableName: TableName.Bookshelf.rawValue, userId: userId)
                
                for  item in localbooks {
                    
                    guard  let book = list.first(where: { (temp) -> Bool in
                        
                        temp.bookId == item.bookId
                        
                    }) else {
                        
                        continue
                    }
                    
                    if !CommonPageViewModel.compareStrs(item.chapterName ?? "", book.chapterName ?? "")
                    {
                        item.chapterName = book.chapterName
                        
                        item.isNew = "1"
                        
                        result = true
                    }
                    
                }
                
                if result {
                    
                    ViewModelInstance.instance.bookShelf.bookList = localbooks
                    
                    ViewModelInstance.instance.bookShelf.needRefresh = true
                    
                    BookListDBHelpr.saveHomeCache(tableName: TableName.Bookshelf.rawValue, books: localbooks, userId: userId, completion: nil)

                }
                
                return result
            }
            
            
        } catch {
            
            return result
        }
        
    }
    
    
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

