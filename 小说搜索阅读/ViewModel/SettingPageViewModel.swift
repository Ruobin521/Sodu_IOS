//
//  SettingPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class SettingPageViewModel {
    
    var switchSettingList = [SettingEntity]()
    var secondarySettingList = [SettingEntity]()
    
    init() {
        
        let aitem0 = SettingEntity()
        
        aitem0.type = SettingType.Secondary
        aitem0.txtTitle = "个人中心"
        aitem0.icon =  "person"
        
        secondarySettingList.append(aitem0)
        
        
        let aitem1 = SettingEntity()
        aitem1.type = SettingType.Secondary
        aitem1.txtTitle = "下载中心"
        aitem1.icon =  "download"
        
        secondarySettingList.append(aitem1)
        
        
        
        let item1 = SettingEntity()
        
        item1.type = SettingType.Swich
        item1.txtTitle = "自动添加到书架"
        item1.icon =  "addbook"
        item1.key = SettingKey.IsAutoAddToShelf
        item1.value =  UserDefaultsHelper.getBoolUserDefaultByKey(key: item1.key!)
        
        switchSettingList.append(item1)
        
        
        let item2 = SettingEntity()
        
        item2.type = SettingType.Swich
        item2.txtTitle = "在2G/3G/4G下缓存"
        item2.icon =  "wwan"
        item2.key = SettingKey.IsDownLoadOnWWAN
        item2.value =  UserDefaultsHelper.getBoolUserDefaultByKey(key: item2.key!)
        
        switchSettingList.append(item2)
        
    }
    
    
    
}
