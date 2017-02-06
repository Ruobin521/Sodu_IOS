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
    
    
    static func getStringValue(key:SettingKey) -> String? {
        
        guard  let value = UserDefaults.standard.string(forKey: key.rawValue) else {
            
            return nil
        }
        
        return value
    }
    
    
    
    
    static func getFloatValue(key:SettingKey) -> Float {
        
        let value = UserDefaults.standard.float(forKey: key.rawValue)
        
        return value
    }
    
    
    
    
    static func getIntValue(key:SettingKey) -> Int {
        
        let value = UserDefaults.standard.integer(forKey: key.rawValue)
        
        return value
    }
    
    
    
    static func getBoolValue(key:SettingKey) -> (Bool)? {
        
        let value = UserDefaults.standard.value(forKey: key.rawValue)
        
        return value as? Bool
        
    }
    
    
    static func setUserDefaultsValueForKey(key:SettingKey,value:Any) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
        let value = UserDefaults.standard.value(forKey: key.rawValue)
        
        print( "存储设置数据完成：\(key.rawValue) : \(value)")
        
        UserDefaults.standard.synchronize()
        
    }
    
    
    
}
