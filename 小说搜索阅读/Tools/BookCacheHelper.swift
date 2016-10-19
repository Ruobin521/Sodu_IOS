//
//  BookCacheHelper.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/19.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

enum ListType :String {
    
    case BookShelf = "BookShelf"
    case Rank = "Rank"
    case Hot = "Hot"
    case Recommend = "Recommend"
    
}



/// 将book列表序列化到本地文件 ，下次启动时读取，
class BookCacheHelper {
    
    
    static func SavaBookListAsFile(_ list:[Book] ,_ type:ListType) {
        
        guard   let str = list.toJSONString() else {
            
            return
        }
        
        /// 沙盒目录
        let docdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let jsonPath = (docdir as NSString).appendingPathComponent( type.rawValue + ".json")
        
        /// 将数据写入沙盒文件
        // (str as NSString).write(toFile: jsonPath, atomically: true)
        
        
        try? str.write(toFile: jsonPath, atomically: true, encoding: String.Encoding.utf8)
        
    }
    
    
    
    
    static  func ReadBookListCacheFromFile(_ type:ListType) -> [Book]{
        
        var list = [Book]()
        
        //获取沙盒路径
        let docdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let jsonPath = (docdir as NSString).appendingPathComponent(type.rawValue + ".json")
        
        //加载data
        guard  let data = NSData(contentsOfFile: jsonPath) else {
            
            return list
        }
        
        
        //反序列化data
        guard  let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! [[String:String]] else {
            
            return list
        }
        
        for item in array {
            
            let b = Book()
            b.bookId = item["bookId"]
            b.bookName = item["bookName"]
            b.chapterName = item["chapterName"]
            b.updateListPageUrl = item["updateListPageUrl"]
            b.updateTime = item["bookId"]
            
            list.append(b)
        }
   
    
        return list
    }
}


  
