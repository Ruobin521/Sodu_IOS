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

class SettingPageViewModel:NSObject {
    
    
    
     var isAutoAddToShelf = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsAutoAddToShelf)
     var isDownLoadOnWWAN = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsDownLoadOnWWAN)
    
    
    //正文
    
    /// 滚动方向
    lazy var contentOrientation = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentOrientation) ?? "H"
    
    /// 夜间模式
    lazy var isMoomlightMode = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsMoomlightMode)
    
    /// 正文字体大小
    lazy var contentTextSize:Float = (UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentTextSize)  == Float(0) ) ? Float(20) : UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentTextSize)
    
    /// 行高
    lazy var contentLineSpace:Float = (UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentLineSpace)  == Float(0) ) ? Float(10) :  UserDefaultsHelper.getFloatUserDefaultByKey(key: .ContentLineSpace)
    
    /// 背景色
    lazy var contentBackColor = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentBackColor) ?? "#AAC5AA"
    
    /// 字体颜色
    lazy var contentTextColor = UserDefaultsHelper.getUserDefaultByKey(key:  .ContentTextColor) ??  "#1B3D25"
    
    
    
    var secondarySettingList = [SettingEntity]()
    var switchSettingList = [SettingEntity]()
    
    
    override init() {
        
        super.init()
        
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
        
        /// 按钮数据数组
        let settingInfo = [["imageName": "person", "title": "个人中心","type":"0","controller":"PersonCenterViewController"],
                           ["imageName": "download", "title": "下载中心","type":"0","controller":"DownCenterViewController"],
                           ["imageName": "history", "title": "历史记录","type":"0","controller":"HistoryPageViewController"],
                           ["key":"IsAutoAddToShelf","property":"isAutoAddToShelf","imageName": "addbook", "title": "自动添加到书架存","type":"1"],
                           ["key":"IsDownLoadOnWWAN","property":"isDownLoadOnWWAN","imageName": "wwan", "title": "在2G/3G/4G下缓存","type":"1"],
                           ]
        
        
        for dic in  settingInfo {
            
            
            guard
                let title = dic["title"],
                let imageName = dic["imageName"] ,
                let type = dic["type"]
                
                else {
                    
                    continue
                    
            }
            
            let settingItem = SettingEntity()
            
            settingItem.icon = imageName
            
            settingItem.title = title
            
            
            if type == "0"  {
                
                if  let clsName = dic["controller"] {
                    
                    settingItem.controller = clsName
                    
                    settingItem.settingType = SettingType.Secondary
                    
                    secondarySettingList.append(settingItem)
                    
                }
                
            }  else if type == "1" {
                
                settingItem.settingType = SettingType.Swich
                
                if let rawValue = dic["key"], let key =  SettingKey(rawValue: rawValue) ,let propertyName =  dic["property"]{
                    
                    settingItem.settingKey = key
                    
                    let value = self.getValueOfProperty(key: propertyName)
                    
                    settingItem.value = value
                    
                    switchSettingList.append(settingItem)
                    
                }
             
                
            }
            
        }
        
    }
    
}
