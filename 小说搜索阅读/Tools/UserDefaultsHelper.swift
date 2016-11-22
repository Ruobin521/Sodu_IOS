
//
//  VersionHelper.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/30.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit


enum SettingKey : String {
    
    case UserNameKey = "UserName"
    case PasswordKey = "Password"
    case AppVersionKey = "AppVersion"
    case IsFirstLaunchKey = "IsFirstLaunch"
    case IsAutoAddToShelf = "IsAutoAddToShelf"
    case IsDownLoadOnWWAN = "IsDownLoadOnWWAN"
    case IsMoomlightMode = "isMoomlightMode"
}

class UserDefaultsHelper {
    
    
    static func getUserDefaultByKey(key:SettingKey) -> String? {
        
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? String
        
        return value
    }
    
    static func getBoolUserDefaultByKey(key:SettingKey) -> Bool {
        
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? Bool  ?? false
        
        print( "\(key.rawValue) : \(value)")
        
        return value
    }
    
    
    
    static func setUserDefaultsValueForKey(key:SettingKey,value:Any) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? Bool
        
        print( "\(key.rawValue) : \(value)")
        
    }
    
    
    
}
