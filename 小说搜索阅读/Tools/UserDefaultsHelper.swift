//
//
//  VersionHelper.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/30.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit




class UserDefaultsHelper {
    
    
    static func getUserDefaultByKey(key:SettingKey) -> String? {
        
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? String
        
        return value
    }
    
    static func getBoolUserDefaultByKey(key:SettingKey) -> Bool {
         
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? Bool  ?? false
        
        print( "获取设置数据完成：\(key.rawValue) : \(value)")
        
        return value
    }
    
    
    static func getFloatUserDefaultByKey(key:SettingKey) -> Float {
        
        guard let value = UserDefaults.standard.value(forKey: key.rawValue) as? String else{
            
            return 0
        }
        
        
        return Float(value)!
    }
    
    
    
    
    static func setUserDefaultsValueForKey(key:SettingKey,value:Any) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
        let value = UserDefaults.standard.value(forKey: key.rawValue) as? Bool
        
        print( "存储设置数据完成：\(key.rawValue) : \(value)")
        
    }
    
    
    
}
