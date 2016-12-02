//
//  BookShelfPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class BookShelfPageViewModel {
    
    lazy var bookList = [Book]()
    
    let userId  = ViewModelInstance.instance.userId
    
    
    func loadCacheData(_ vc:BaseViewController) {
        
        BookListDBHelpr.loadHomeCache(tableName: TableName.Bookshelf.rawValue,userId: userId, completion: { (isSuccess, tempList) in
            
            if  isSuccess {
                
                if self.bookList.count == 0 {
                    
                    self.bookList.removeAll()
                    
                    self.bookList += tempList!
                    
                    vc.tableview?.reloadData()
                }
            }
        })
    }
    
    
    func loadBookShelfPageData(completion:@escaping (_ isSuccess:Bool)->()) {
        
        
        let urlStr =  SoDuUrl.bookShelfPage
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    
                }  else {
                    
                    let array = AnalisysBookListHtmlHelper.analisysBookShelfHtml(html)
                     
                    self.compareBookWithLoacl(requestBooks: array, loacalBooks: self.bookList)
                    
                    self.bookList.removeAll()
                    
                    self.bookList += array
                    
                    BookListDBHelpr.saveHomeCache(tableName: TableName.Bookshelf.rawValue, books: self.bookList, userId: self.userId, completion: nil)
                    
                    completion(true)
                    
                }
                
            }
        }
    }
    
    
    
    
    func removeBookFromList(_ book:Book,completion:@escaping (_ isSuccess:Bool)->())  {
        
        HttpUtil.instance.request(url: SoDuUrl.bookShelfPage + "?id=\(book.bookId!)", requestMethod: .GET,postStr:nil,true) { (str, isSuccess) in
            
            DispatchQueue.main.async {
                
                if isSuccess && (str?.contains("取消收藏成功"))!{
                    
                    SoDuSQLiteManager.shared.deleteBooks(books: [book], tableName: TableName.Bookshelf.rawValue, userId: self.userId, completion: { (isSuccess) in
                        
                        if !isSuccess {
                            
                            completion(false)
                            
                        } else {
                            
                            completion(true)
                            
                        }
                        
                        
                    })
                    
                }
            }
        }
        
    }
    
    
    func compareBookWithLoacl(requestBooks:[Book],loacalBooks:[Book]) {
        
        if  loacalBooks.count == 0 {
            
            return
            
        }
        
        
        for book in requestBooks {
            
            
            guard  let tempbook = loacalBooks.first(where: { (item) -> Bool in
                
                item.bookId == book.bookId
                
            }) else {
                
                continue
                
            }
            
            if compareStrs(tempbook.lastReadChapterName!,book.chapterName!) {
                
                book.isNew = "0"
                
            } else {
                
                book.isNew = "1"
                
                book.lastReadChapterName = tempbook.lastReadChapterName
            }
            
            
        }
        
    }
    
    
    
    func compareStrs(_ str1:String,_ str2:String) -> Bool {
        
        var string1 = str1
        var string2 = str2
        
        string1 = string1.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "【", with: "")
            .replacingOccurrences(of: "】", with: "")
            .replacingOccurrences(of: "，", with: "")
            .replacingOccurrences(of: "。", with: "")
            .replacingOccurrences(of: "《", with: "")
            .replacingOccurrences(of: "》", with: "")
            .replacingOccurrences(of: "？", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
        
        string2 = string2.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "【", with: "")
            .replacingOccurrences(of: "】", with: "")
            .replacingOccurrences(of: "，", with: "")
            .replacingOccurrences(of: "。", with: "")
            .replacingOccurrences(of: "《", with: "")
            .replacingOccurrences(of: "》", with: "")
            .replacingOccurrences(of: "？", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
        
        if string1 == string2 ||  string1.contains(string2)  || string2.contains(string1) {
            
            return true
            
        }  else {
            
            return false
            
        }
        
        
    }
    
    
    
    func updateBook(book:Book,completion:@escaping (_ isSuccess:Bool) -> ()) {
        
        SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [book], tableName: TableName.Bookshelf.rawValue,userId: self.userId) { (isSuccess) in
            
            if isSuccess {
                
                completion(isSuccess)
            }
            
        }
    }
}
