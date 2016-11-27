//
//  SettingPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


enum SettingKey : String {
    
    case UserNameKey = "UserName"
    case PasswordKey = "Password"
    case AppVersionKey = "AppVersion"
    case IsFirstLaunchKey = "IsFirstLaunch"
    case IsAutoAddToShelf = "IsAutoAddToShelf"
    case IsDownLoadOnWWAN = "IsDownLoadOnWWAN"
    
    
    /// 正文阅读设置选项
    case ContentOrientation = "ContentOrientatione"
    case IsMoomlightMode = "IsMoomlightMode"
    case ContentTextSize = "ContentTextSize"
    case ContentLineSpace = "ContentLineSpace"
    case ContentTextColor = "ContentTextColor"
    case ContentBackColor = "ContentBackColor"
}

class SettingPageViewModel {
    
    
    
    lazy var isAutoAddToShelf = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsAutoAddToShelf)
    lazy var isDownLoadOnWWAN = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsDownLoadOnWWAN)
    
    
    //正文
    
    /// 滚动方向
    lazy var contentOrientation = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentOrientation)
    
    /// 夜间模式
    lazy var isMoomlightMode = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsMoomlightMode)
     
    /// 正文字体大小
    lazy var contentTextSize:Float = (UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentTextSize)  == Float(0) ) ? Float(20) : UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentTextSize)
    
    /// 行高
    lazy var contentLineSpace:Float = (UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentLineSpace)  == Float(0) ) ? Float(10) :  UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentLineSpace)
    
    /// 背景色
    lazy var contentBackColor = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentBackColor) ?? "AAC5AA"
    
    /// 字体颜色
    lazy var contentTextColor = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentTextColor) ??  "1B3D25"
    
    
    
    
    
    var secondarySettingList = [SettingEntity]()
    var switchSettingList = [SettingEntity]()
    
    
    init() {
        
        initSettingList()
    }
    
    
    
}

extension SettingPageViewModel {
    
    
    func setValue(_ key:SettingKey,_ value:Any) {
        
        switch key {
            
        case SettingKey.IsAutoAddToShelf:
            
            isAutoAddToShelf = value as! Bool
            
        case SettingKey.IsDownLoadOnWWAN:
            
            isDownLoadOnWWAN = value as! Bool
            
        case SettingKey.IsMoomlightMode:
            
            if isMoomlightMode != (value as? Bool) {
                
                isMoomlightMode = value as! Bool
            }
            
            return
            
        default: break
            
        }
        
        UserDefaultsHelper.setUserDefaultsValueForKey(key: key, value: value)
    }
    
}


extension  SettingPageViewModel {
    
    
    func  initSettingList() {
        
        let aitem0 = SettingEntity()
        aitem0.index = 0
        aitem0.settingType = SettingType.Secondary
        aitem0.txtTitle = "个人中心"
        aitem0.icon =  "person"
        aitem0.controller =  "PersonCenterViewController"
        
        secondarySettingList.append(aitem0)
        
        let aitem1 = SettingEntity()
        aitem1.index = 1
        aitem1.settingType = SettingType.Secondary
        aitem1.txtTitle = "下载中心"
        aitem1.icon =  "download"
        aitem1.controller =  "DownCenterViewController"
        
        secondarySettingList.append(aitem1)
        
        let item1 = SettingEntity()
        item1.index = 2
        item1.settingType = SettingType.Swich
        item1.txtTitle = "自动添加到书架"
        item1.icon =  "addbook"
        item1.key = SettingKey.IsAutoAddToShelf
        item1.value =  isAutoAddToShelf
        
        switchSettingList.append(item1)
        
        
        let item2 = SettingEntity()
        item2.index = 3
        item2.settingType = SettingType.Swich
        item2.txtTitle = "在2G/3G/4G下缓存"
        item2.icon =  "wwan"
        item2.key = SettingKey.IsDownLoadOnWWAN
        item2.value =  isDownLoadOnWWAN
        
        switchSettingList.append(item2)
        
        
    }
    
    
    
}
