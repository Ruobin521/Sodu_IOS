//
//  LoaclBookPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class LoaclBookPageViewModel {
    
    var bookList:[Book] = [Book]()
    
    
    
    
    func loadLoaclBooks(completion:(_ isSuccess:Bool) -> ())  {
        
        let  books =  SoDuSQLiteManager.shared.selectBook(tableName: TableName.Loaclbook.rawValue)
        
        if books.count > 0 {
            
            completion(true)
            
            self.bookList = books.reversed()
            
        } else {
            
            completion(false)
        }
    }
    
    
    
    
    
    func updateBookDB(book:Book,completion:((_ isSuccess:Bool) -> ())?) {
        
        SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [book], tableName: TableName.Loaclbook.rawValue) { (isSuccess) in
            
            if isSuccess {
                
                completion?(isSuccess)
            }
            
        }
    }
    
    
    
    func removeBookFromList(_ book:Book,completion:@escaping (_ isSuccess:Bool)->())  {
        
         SoDuSQLiteManager.shared.deleteBookCatalogs(bookId: book.bookId!) { (isDeleteCatalogSuccess) in
            
            if !isDeleteCatalogSuccess {
                
                completion(false)
                
                return
                
            }  else {
                
                SoDuSQLiteManager.shared.deleteBooks(books: [book], tableName: TableName.Loaclbook.rawValue, completion: { (isDeleteBookSuccess) in
                    
                    if !isDeleteBookSuccess {
                        
                        completion(false)
                        
                    } else {
                        
                        completion(true)
                        
                    }
                    
                })
                 
            }
            
        }
        
    }
    
}
