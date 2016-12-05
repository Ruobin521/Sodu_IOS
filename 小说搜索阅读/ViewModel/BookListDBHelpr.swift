//
//  BookListDAL.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/2.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

enum TableName : String {
    
    case Bookshelf = "bookshelf"
    
    case Rank = "rank"
    
    case Recommend = "recommend"
    
    case History = "history"
    
    case Catalog = "catalog"
    
}


/// DAL - Data Access Layer 数据访问层
class BookListDBHelpr {
    
    
    class func loadHistoryList(completion:(_ isSuccess:Bool,_ books:[Book]?) -> ()) {
        
        let array = SoDuSQLiteManager.shared.selectBook(tableName: TableName.History.rawValue, userId: nil, orderByTime: true)
        
        // 判断数组的数量，没有数据返回的是没有数据的空数组 []
        if array.count > 0 {
            
            completion(true,array)
            
            
        } else {
            
            completion(false,[])
        }
        
    }
    
    
}



// MARK: - 首页缓存操作
extension BookListDBHelpr {
    
    
    /// 加载首页缓存数据
    ///
    /// - Parameters:
    ///   - tableName: <#tableName description#>
    ///   - completion: <#completion description#>
    class func loadHomeCache(tableName:String,userId:String? = nil,completion:(_ isSuccess:Bool,_ books:[Book]?) -> ())  {
        
        let  books =  SoDuSQLiteManager.shared.selectBook(tableName: tableName, userId: userId)
        
        if books.count > 0 {
            
            completion(true,books)
            
        } else {
            
            completion(false,[])
        }
    }
    
    
    
    /// 清空
    ///
    /// - Parameters:
    ///   - tableName: <#tableName description#>
    ///   - books: <#books description#>
    ///   - completion: <#completion description#>
    class func saveHomeCache(tableName:String,books:[Book],userId:String? = nil,completion:((_ isSuccess:Bool) -> ())?) {
        
        SoDuSQLiteManager.shared.clearAll(tableName: tableName) { (isSuccess) in
            
            SoDuSQLiteManager.shared.insertOrUpdateBooks(books: books, tableName: tableName,userId: userId) { (isSuccess) in
                
                completion?(isSuccess)
                
            }
        }
        
    }
    
}




















