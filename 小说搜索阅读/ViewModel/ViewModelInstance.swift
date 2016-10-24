//
//  ViewModelInstance.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class ViewModelInstance {
    
    static  var Instance = ViewModelInstance()
    
    lazy var rank = RankListPageViewModel()
    
    lazy var bookShelf = BookShelfPageViewModel()
    
    lazy var HotAndRecommend = HotAndRecommendPageViewModel()
    
    
    
}
