//
//  SettingPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class SettingPageViewModel {
    
    lazy var isAutoAddToShelf = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsAutoAddToShelf)
    lazy var IsDownLoadOnWWAN = UserDefaultsHelper.getBoolUserDefaultByKey(key:  .IsDownLoadOnWWAN)
    
    
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
            
            IsDownLoadOnWWAN = value as! Bool
            
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
        item2.value =  IsDownLoadOnWWAN
        
        switchSettingList.append(item2)
        
        
    }
    
    
    
}
