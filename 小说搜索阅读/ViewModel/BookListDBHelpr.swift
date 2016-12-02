//
//  BookListDAL.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/2.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

enum TableName {
    
    case bookshelf
    
    case rank
    
    case recommend
    
    case history
    
}


/// DAL - Data Access Layer 数据访问层
class BookListDBHelpr {
    
    
    class func loadHistoryList(completion:(_ isSuccess:Bool,_ books:[Book]?) -> ()) {
        
        let array = SoDuSQLiteManager.shared.selectHistory()
        
        // 判断数组的数量，没有数据返回的是没有数据的空数组 []
        if array.count > 0 {
            
            completion(true,array)
            
            return
            
        } else {
            
            completion(false,nil)
        }
        
    }
    
    
}
