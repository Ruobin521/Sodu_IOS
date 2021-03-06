//
//  SettingPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
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
    case IsLocalBookAutoDownload = "IsLocalBookAutoDownload"
    
    case IsDownLoadOnWWAN = "IsDownLoadOnWWAN"
    case IsReadOnShelf = "IsReadOnShelf"
    
    /// 正文阅读设置选项
    case ContentOrientation = "ContentOrientatione"
    case IsMoomlightMode = "IsMoomlightMode"
    case ContentTextSize = "ContentTextSize"
    case ContentLineSpace = "ContentLineSpace"
    case ContentAndTextColorIndex = "ContentAndTextColorIndex"
    
    case ContentLightValue = "ContentLightValue"
    
}

class SettingPageViewModel:NSObject {
    
    
    lazy var _isAutoAddToShelf:Bool =  UserDefaultsHelper.getBoolValue(key:  .IsAutoAddToShelf) ?? false
    
    var isAutoAddToShelf:Bool {
        
        get{
            
            return _isAutoAddToShelf
            
        }
        set{
            
            if _isAutoAddToShelf != newValue
            {
                
                _isAutoAddToShelf = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .IsAutoAddToShelf, value: newValue)
                
            }
        }
        
    }
    
    lazy var _isLocalBookAutoDownload:Bool =  UserDefaultsHelper.getBoolValue(key:  .IsLocalBookAutoDownload) ?? true
    
    var isLocalBookAutoDownload:Bool {
        
        get{
            
            return _isLocalBookAutoDownload
            
        }
        set{
            
            if _isLocalBookAutoDownload != newValue
            {
                
                _isLocalBookAutoDownload = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .IsLocalBookAutoDownload, value: newValue)
                
            }
        }
        
    }
    
 
    
    
    var _isDownLoadOnWWAN:Bool = UserDefaultsHelper.getBoolValue(key:  .IsDownLoadOnWWAN) ?? false
    
    var isDownLoadOnWWAN:Bool {
        
        get{
            
            return _isDownLoadOnWWAN
            
        }
        set{
            
            if _isDownLoadOnWWAN != newValue
            {
                
                _isDownLoadOnWWAN = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .IsDownLoadOnWWAN, value: newValue)
                
            }
        }
        
    }
    //正文方向
    lazy private var  _contentOrientation:UIPageViewControllerNavigationOrientation = ( UserDefaultsHelper.getStringValue(key:  .ContentOrientation) ==  "V" ) ? UIPageViewControllerNavigationOrientation.vertical : UIPageViewControllerNavigationOrientation.horizontal
    
    
    /// 滚动方向
    var contentOrientation:UIPageViewControllerNavigationOrientation  {
        
        get {
            
            // return  UIPageViewControllerNavigationOrientation.vertical
            
            return _contentOrientation
        }
        
        set {
            
            if newValue != _contentOrientation {
                
                _contentOrientation = newValue
                
                if newValue == .horizontal {
                    
                    UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentOrientation, value: "H")
                    
                } else {
                    
                    UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentOrientation, value: "V")
                    
                }
                
                
            }
        }
        
    }
    
    
    
    /// 夜间模式
    lazy  private var _isMoomlightMode = UserDefaultsHelper.getBoolValue(key:  .IsMoomlightMode) ?? false
    
    var isMoomlightMode:Bool  {
        
        get {
            
            return _isMoomlightMode
        }
        
        set {
            
            if newValue != _isMoomlightMode {
                
                _isMoomlightMode = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .IsMoomlightMode, value: newValue)
                
            }
        }
        
    }
    
    
    
    
    /// 正文字体大小 16 - 26 默认20
    lazy private var _contentTextSize:Float = (UserDefaultsHelper.getFloatValue(key: .ContentTextSize)  == Float(0) ) ? Float(20) : UserDefaultsHelper.getFloatValue(key: .ContentTextSize)
    
    var contentTextSize:Float  {
        
        get {
            
            return _contentTextSize
        }
        
        set {
            
            if newValue != _contentTextSize {
                
                _contentTextSize = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentTextSize, value: newValue)
                
            }
        }
        
    }
    
    
    
    /// 行高 范围从5 - 25 默认10
    lazy private var _contentLineSpace:Float = (UserDefaultsHelper.getFloatValue(key: .ContentLineSpace)  == Float(0) ) ? Float(10) :  UserDefaultsHelper.getFloatValue(key: .ContentLineSpace)
    
    var contentLineSpace:Float  {
        
        get {
            
            return _contentLineSpace
        }
        
        set {
            
            if newValue != _contentLineSpace {
                
                _contentLineSpace = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentLineSpace, value: newValue)
            }
        }
        
    }
    
    
    /// 亮度
    lazy private var _contentLightValue:Float = (UserDefaultsHelper.getFloatValue(key: .ContentLightValue)  == Float(0) ) ? Float(1) :  UserDefaultsHelper.getFloatValue(key: .ContentLightValue)
    
    var contentLightValue:Float  {
        
        get {
            
            return _contentLightValue
        }
        
        set {
            
            if newValue != _contentLightValue {
                
                _contentLightValue = newValue
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentLightValue, value: newValue)
            }
        }
        
    }
    
    
    /// 背景色，字体颜色 index 获取索引
    lazy private var _contentAndTextColorIndex = UserDefaultsHelper.getIntValue(key:.ContentAndTextColorIndex)
    
    var contentAndTextColorIndex:Int  {
        
        get {
            
            return _contentAndTextColorIndex
        }
        
        set {
            
            if newValue != _contentAndTextColorIndex {
                
                _contentAndTextColorIndex = newValue
                
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .ContentAndTextColorIndex, value: newValue)
            }
        }
        
    }
    
    
    
    var secondarySettingList = [SettingEntity]()
    var switchSettingList = [SettingEntity]()
    var alterSettingList = [SettingEntity]()
    
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
            
        case SettingKey.IsLocalBookAutoDownload:
            
            isLocalBookAutoDownload = value as! Bool
            
        default: break
            
        }
        
    }
    
    func getValue(_ key:SettingKey) -> Bool {
        
        switch key {
            
        case SettingKey.IsAutoAddToShelf:
            
            return  isAutoAddToShelf
            
        case SettingKey.IsDownLoadOnWWAN:
            
            return isDownLoadOnWWAN
            
     
        case SettingKey.IsLocalBookAutoDownload:
            
            return isLocalBookAutoDownload
            
        default:
            
            return false
            
        }
        
    }
    
}


extension  SettingPageViewModel {
    
    
    func  initSettingList() {
        
        /// 按钮数据数组
        let settingInfo = [["imageName": "person",   "title": "个人中心","controller":"PersonCenterViewController","type":"0"],
                           ["imageName": "download", "title": "下载中心","controller":"DownCenterViewController","type":"0"],
                           ["imageName": "history",  "title": "历史记录","controller":"HistoryPageViewController","type":"0"],
                           ["imageName": "addbook",  "title": "自动添加到个人书架", "key":"IsAutoAddToShelf","property":"isAutoAddToShelf","type":"1"],
                           ["imageName": "addbook2", "title": "自动更新本地收藏",   "key":"IsLocalBookAutoDownload","property":"isLocalBookAutoDownload","type":"1"],
                           ["imageName": "wwan",     "title": "在2G/3G/4G下缓存",  "key":"IsDownLoadOnWWAN","property":"isDownLoadOnWWAN", "type":"1"],
                           ["imageName": "mzsm",     "title": "免责声明","index" : "0","action":"mzsmAction", "type":"2"]
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
                
                if let rawValue = dic["key"], let key =  SettingKey(rawValue: rawValue) ,let propertyName =  dic["property"] {
                    
                    settingItem.settingKey = key
                    
                    let value = self.getValueOfProperty(key: propertyName)
                    
                    settingItem.value = value
                    
                    switchSettingList.append(settingItem)
                    
                }
                
            }   else if type == "2" {
                
                settingItem.settingType = SettingType.Alter
                
                alterSettingList.append(settingItem)
                
            }
            
        }
        
    }
}


