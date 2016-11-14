//
//  SettingEntity.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

enum SettingType {
    
    case  Secondary
    case  Swich
    
}


class SettingEntity :NSObject {
    
    var index:Int! = 0
    
    ///设置类型
    var settingType:SettingType?
    
    ///标题
    var txtTitle:String?
    
    ///标题
    var icon:String?
    
    ///key 用户存储
    var key:SettingKey?
    
    ///值
    var value:Any?
    
    ///二级界面
    var controller:String?
    
    
}
