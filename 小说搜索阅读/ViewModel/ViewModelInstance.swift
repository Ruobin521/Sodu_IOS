//
//  ViewModelInstance.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class ViewModelInstance {
    
    static  var instance = ViewModelInstance()
    
    lazy var rank = RankListPageViewModel()
    
    lazy var bookShelf = BookShelfPageViewModel()
    
    lazy var hotAndRecommend = HotAndRecommendPageViewModel()
    
    lazy var setting = SettingPageViewModel()
    
    lazy var history = HistoryPageViewModel()
    
    var  userId:String?
    
    var  userLogon = false {
        
        didSet {
            
            if userLogon {
                
                userId = UserDefaultsHelper.getStringValue(key: .UserNameKey)

            } else {
                
                userId = nil
            }
            
        }
        
    }
    
}
