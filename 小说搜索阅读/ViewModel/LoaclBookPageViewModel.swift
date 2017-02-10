//
//  LoaclBookPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class LoaclBookPageViewModel {
    
    var isChecking:Bool = false
    
    var bookList = [LocalBookItemViewModel]()
    
    func loadLoaclBooks(completion:(_ isSuccess:Bool) -> (),checkCompletion:@escaping ()->())  {
        
        if bookList.count > 0 {
            
            if   bookList.first(where: { (item) -> Bool in
                
                item.isUpdating == true
                
            }) != nil  {
                
                completion(true)
                
                checkCompletion()
                
                return
                
            }
        }
        
        let  books =  SoDuSQLiteManager.shared.selectBook(tableName: TableName.Loaclbook.rawValue)
        
        if books.count > 0 {
            
            self.bookList.removeAll()
            
            completion(true)
            
            var count = books.count
            
            for item in books.reversed() {
                
                let temp = LocalBookItemViewModel()
                
                temp.book = item
                
                bookList.append(temp)
                
                temp.checkUpdate() {
                    
                    if ViewModelInstance.instance.setting.isLocalBookAutoDownload {
                        
                        temp.downLoadUpdate(completion: {
                            
                            count -= 1
                            
                            if count == 0 {
                                
                                checkCompletion()
                            }
                            
                            
                        })
                        
                    } else {
                        
                        count -= 1
                        
                        if count == 0 {
                            
                            checkCompletion()
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
            
            bookList.removeAll()
            
            completion(false)
            
            checkCompletion()
        }
    }
    
    
    
    
    
    func updateBookDB(book:Book,completion:((_ isSuccess:Bool) -> ())?) {
        
        SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [book], tableName: TableName.Loaclbook.rawValue) { (isSuccess) in
            
            if isSuccess {
                
                let tempItem = self.bookList.first(where: { (item) -> Bool in
                    
                    item.book.bookId == book.bookId
                    
                })
                
                if tempItem == nil {
                    
                    let tempBook = LocalBookItemViewModel()
                    
                    tempBook.book = book
                    
                    self.bookList.insert(tempBook, at: 0)
                    
                } else {
                    
                    self.bookList.remove(at:  self.bookList.index(of: tempItem!)! )
                    
                    tempItem?.book = book.clone()
                    
                    self.bookList.insert(tempItem!, at: 0)
                }
                
                completion?(isSuccess)
            }
            
        }
    }
    
    
    
    func removeBookFromList(_ bookid:String,completion:@escaping (_ isSuccess:Bool)->())  {
        
        SoDuSQLiteManager.shared.deleteBookCatalogs(bookId: bookid) { (isDeleteCatalogSuccess) in
            
            if !isDeleteCatalogSuccess {
                
                completion(false)
                
                return
                
            }  else {
                
                SoDuSQLiteManager.shared.deleteBooks(books: [bookid], tableName: TableName.Loaclbook.rawValue, completion: { (isDeleteBookSuccess) in
                    
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
