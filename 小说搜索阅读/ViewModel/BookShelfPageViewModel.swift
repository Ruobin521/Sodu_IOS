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
    
    
    var userId:String? {
        
        get {
            
            return  UserDefaultsHelper.getStringValue(key: .UserNameKey)
        }
        
    }
    
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
                    
                    if self.userId != nil  ||  !(self.userId?.isEmpty)! {
                        
                        BookListDBHelpr.saveHomeCache(tableName: TableName.Bookshelf.rawValue, books: self.bookList, userId: self.userId!, completion: nil)
                        
                    }
                    
                    completion(true)
                    
                }
                
            }
        }
    }
    
    
    
    
    func removeBookFromList(_ book:Book,completion:@escaping (_ isSuccess:Bool)->())  {
        
        HttpUtil.instance.request(url: SoDuUrl.bookShelfPage + "?id=\(book.bookId!)", requestMethod: .GET,postStr:nil,true) { (str, isSuccess) in
            
            DispatchQueue.main.async {
                
                if isSuccess && (str?.contains("取消收藏成功"))!{
                    
                    SoDuSQLiteManager.shared.deleteBooks(books: [book.bookId!], tableName: TableName.Bookshelf.rawValue, userId: self.userId, completion: { (isSuccess) in
                        
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
            
            if tempbook.lastReadChapterName == nil {
                
                book.isNew = "0"
                
                tempbook.lastReadChapterName = book.lastReadChapterName
                
                continue
            }
            
            if CommonPageViewModel.compareStrs(tempbook.lastReadChapterName ?? "",book.chapterName!) {
                
                book.isNew = "0"
                
            } else {
                
                book.isNew = "1"
                
                book.lastReadChapterName = tempbook.lastReadChapterName
            }
            
        }
        
    }
    
    

    
    
    
    
    func setHadReaded(book:Book,completion:((_ isSuccess:Bool) -> ())?) {
        
        let temp = book.clone()
        
        temp.isNew = "0"
        temp.lastReadChapterName = book.chapterName
        temp.LastReadContentPageUrl = book.chapterUrl
        
        updateBook(book: temp) { (isSuccess) in
            
            if isSuccess {
                
                book.isNew = "0"
                book.lastReadChapterName = book.chapterName
                book.LastReadContentPageUrl = book.chapterUrl
                
                completion?(true)
            }
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
