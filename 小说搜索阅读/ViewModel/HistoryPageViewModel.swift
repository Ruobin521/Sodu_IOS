//
//  HistoryPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/28.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


class HistoryPageViewModel {
    
    var bookList = [Book]()
    
    
    
    
}

/// MARK: 对历史记录的操作
extension HistoryPageViewModel {
    
    //插入新的历史记录
    func insertNewHistoryItem(_ insertBook:Book) {
        
        
        guard let _ = insertBook.bookId , let _ = insertBook.LastReadContentPageUrl   else  {
            
            return
            
        }
        
        let tempBook = insertBook.clone()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = formatter.string(from: Date())
        
        tempBook.updateTime = dateString
        
        SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [tempBook],tableName: TableName.History.rawValue,time:true) { (isSuccess) in
            
            if !isSuccess {
                
                return
                
            }
            
            if let book = self.bookList.first(where: { (temp) -> Bool in tempBook.bookId == temp.bookId }) {
                
                let index = self.bookList.index(of: book)
                
                self.bookList.remove(at: index!)
             
            }
            
            
            self.bookList.insert(tempBook, at: 0)
            
        }
        
    }
    
    
    //删除单挑记录
    func deleteItem(book:Book,completion: @escaping (_ isSuccess:Bool) -> ()) {
        
        SoDuSQLiteManager.shared.deleteBooks(books: [book.bookId!],tableName: TableName.History.rawValue,completion: completion)
        
    }
    
    //删除所有记录
    func clearAll() {
        
        bookList.removeAll()
        
    }
    
    
    ///查询所有记录
    func loadHistoryFormDatabase()
    {
        
        BookListDBHelpr.loadHistoryList { (isSuccess, books) in
            
            if isSuccess {
                
                self.bookList = books!
                
            }
        }
        
    }
    
    
    
}



















