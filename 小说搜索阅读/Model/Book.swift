//
//  Book.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class Book: NSObject,JSON {
    
    
    /// bookId
    var   bookId :String?
    
    /// 书名
    var   bookName : String?
    
    /// 作者
    var   author: String?
    
    /// 章节名称
    var   chapterName : String?
    
    /// 更新章节列表地址
    var   updateListPageUrl : String?
    
    /// 正文页面地址
    var   contentPageUrl : String?
    
    /// 上次阅读至页面地址
    var   LastReadContentPageUrl : String?
    
    /// 更新日期
    var   updateTime:String?
    
    /// 封面名称
    var  coverImage:String?
    
    
    /// 简介
    var   introduction:String?
    
    /// 目录
    var   catalogs:[BookCatalog]?
    
    /// 来源网站名称
    var   lywzName:String?
    
    /// 排行榜数据
    var rankChangeValue:String?
    
}

extension Book {
    
    func  clone() -> Book {
        
        let book = Book()
        
        
        book.author = self.author
        book.bookId = self.bookId
        book.bookName = self.bookName
        
        book.chapterName = self.chapterName
        book.chapterName = self.chapterName
        book.contentPageUrl = self.contentPageUrl
        book.coverImage = self.coverImage
        book.LastReadContentPageUrl = self.LastReadContentPageUrl
        book.lywzName = self.lywzName
        book.updateListPageUrl = self.updateListPageUrl
        book.updateTime = self.updateTime
        
        if catalogs != nil   {
            
            book.catalogs = [BookCatalog]()
            
            for item in catalogs! {
                
                let temp = item.clone()
                
                book.catalogs?.append(temp as! BookCatalog)
                
            }
        }
        
        
        return book
    }
    
    
}


class BookCatalog:NSObject {
    
    var chapterIndex:Int! = 0
    
    var bookId :String?
    
    var chapterName : String?
    
    var chapterUrl : String?
    
    var chapterContent : String?
    
    func  clone() -> NSObject {
        
        let temp = BookCatalog()
        
        temp.chapterIndex = self.chapterIndex
        temp.bookId = self.bookId
        temp.chapterName = self.chapterName
        temp.chapterUrl = self.chapterUrl
        temp.chapterContent = self.chapterContent
        
        return temp
    }
    
    override init() {
        
        super.init()
        
    }
    
    
    convenience init(_ bookId:String?,_ chapterName:String?,_ chapterUrl:String?,_ chapterContent:String?) {
        
        self.init()
        
        self.bookId = bookId
        
        self.chapterName = chapterName
        
        self.chapterUrl = chapterUrl
        
        self.chapterContent = chapterContent
        
    }
    
}
