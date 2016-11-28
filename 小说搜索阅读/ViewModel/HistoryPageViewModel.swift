//
//  HistoryPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/28.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


class HistoryPageViewModel {
    
    var booklist = [Book]()
    
    
    
}

/// MARK: 对历史记录的操作
extension HistoryPageViewModel {
    
    //插入新的历史记录
    func insertNewHistoryItem(_ insertBook:Book) {
        
        
        if let book = booklist.first(where: { (item) -> Bool in
            
            item.bookId == insertBook.bookId
            
        }) {
            
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString = formatter.string(from: Date())
            
            book.updateTime = dateString
            
            book.chapterName = insertBook.chapterName
            
            booklist.append(book)
            
        }
            
        else {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let tempBook = insertBook.clone()
            
            let dateString = formatter.string(from: Date())
            
            tempBook.updateTime = dateString
            
            tempBook.chapterName = insertBook.chapterName
            
            booklist.append(tempBook)
            
        }
        
    }
    
    
    /// 插入数据库
    func insertToDatabase(book:Book) {
        
        
        
        
    }
    
    
    func clearAll() {
        
        booklist.removeAll()
        
    }
    
    
}
