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
    var   coverImageName:String?
    
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
        book.coverImageName = self.coverImageName
        book.LastReadContentPageUrl = self.LastReadContentPageUrl
        book.lywzName = self.lywzName
        book.updateListPageUrl = self.updateListPageUrl
        book.updateTime = self.updateTime
        
        return book
    }

    
}


class BookCatalog:NSObject {
    
    
    var booKId :String?
    
    var chapterName : String?
    
    var chapterUrl : String?
    
    var chapterContent : String?
    
    
}
