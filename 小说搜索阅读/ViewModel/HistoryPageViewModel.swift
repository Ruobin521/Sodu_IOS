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
        
        
        let book = bookList.first(where: { (item) -> Bool in
            
            item.bookId == insertBook.bookId
            
        })
        
        var tempBook = book
        
        if book == nil
            
        {
            tempBook = insertBook.clone()
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString = formatter.string(from: Date())
            
            tempBook?.updateTime = dateString
            
            tempBook?.chapterName = insertBook.chapterName
            
        } else {
            
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString = formatter.string(from: Date())
            
            tempBook?.updateTime = dateString
            
            tempBook?.chapterName = insertBook.chapterName
            
            
            
        }
        
        
        SoDuSQLiteManager.shared.insertOrUpdateHistory(book: tempBook!) { (isSuccess) in
            
            if let index = self.bookList.index(of: tempBook!) {
                
                self.bookList.remove(at: index)
                
            }
            
            self.bookList.insert(tempBook!, at: 0)
            
        }
        
    }
    
    
    //删除单挑记录
    func deleteItem(book:Book,completion: @escaping (_ isSuccess:Bool) -> ()) {
        
        SoDuSQLiteManager.shared.deleteHistory(book: book,completion: completion)
        
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



















