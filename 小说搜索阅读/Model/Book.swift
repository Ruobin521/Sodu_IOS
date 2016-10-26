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
    
    /// 更新日期
    var   updateTime:String?
    
    /// 封面名称
    var   coverImageName:String?
    
    /// 目录
    var   catalogs:[Catalog]?
    
    /// 来源网站名称
    var   lywzName:String?
   
}


class Catalog:NSObject {
    
    
    var booKId :String?
    
    var chapterName : String?
    
    var chapterUrl : String?
    
    var chapterContent : String?

    
}
