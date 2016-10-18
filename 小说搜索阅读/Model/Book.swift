//
//  Book.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class Book: NSObject {
    
    
    var   boolId :String?
    
    var   bookName : String?
    
    var   author: String?
    
    var   chapterName : String?
    
    var   updateListPageUrl : String?
    
    var   updateTime:String?
    
    var   coverImageName:String?
    
    var   catalogs:[Catalog]?
   
}


class Catalog:NSObject {
    
    
    var booKId :String?
    
    var chapterName : String?
    
    var chapterUrl : String?
    
    var chapterContent : String?

    
}
