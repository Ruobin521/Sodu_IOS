//
//  SoDuSQLiteManager.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/2.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import FMDB


class SoDuSQLiteManager {
    
    
    static let shared = SoDuSQLiteManager()
    
    let queue:FMDatabaseQueue
    
    /// 构造函数
    private init() {
        
        //数据库全路径
        let dbName = "sodu.db"
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        path = (path as NSString).appendingPathComponent(dbName)
        
        print(path)
        
        queue = FMDatabaseQueue(path: path)
        
        createTable()
        
    }
    
}



// MARK: - 通用增删改查操作
extension SoDuSQLiteManager {
    
    
    /// 插入或者更新记录 一条或多条
    func insertOrUpdateBooks(books:[Book], tableName:String, userId:String? = nil,time:Bool = false ,completion: ((_ isSuccess:Bool) ->  ())?) {
        
        var result = true
        
        var sql = "INSERT OR REPLACE INTO  \(tableName) (bookid ,book) VALUES (?,?)"
        
        if userId != nil {
            
            sql = "INSERT OR REPLACE INTO  \(tableName) (bookid ,book, userid) VALUES (?,?,?)"
            
        }
        
        if time {
            
            sql = "INSERT OR REPLACE INTO  \(tableName) (bookid ,book, inserttime) VALUES (?,?,?)"
            
        }
        
        
        queue.inTransaction { (db, rollbacl) in
            
            for book  in books {
                
                var parameter = [Any]()
                
                
                guard let  bookid = book.bookId ,let data =  book.toJSONString() else {
                    
                    continue
                }
                
                
                parameter.insert(bookid, at: 0)
                parameter.insert(data, at: 1)
                
                if userId != nil {
                    
                    parameter.append(userId!)
                    
                }
                
                if time {
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    let dateString = formatter.string(from: Date())
                    
                    parameter.append(book.updateTime ?? dateString)
                }
                
                
                if db?.executeUpdate(sql, withArgumentsIn: parameter) == false {
                    
                    rollbacl?.pointee = true
                    
                    result = false
                    
                    break
                    
                }
            }
            
        }
        
        completion?(result)
        
    }
    
    
    //MARK: 查询相应表中的所有数据
    func selectBook(tableName:String,userId:String? = nil,orderByTime:Bool = false) -> [Book] {
        
        var sql = "SELECT  bookid, book FROM \(tableName)\n"
        
        if userId != nil {
            
            sql  += " WHERE userid ='\(userId!)' "
        }
        
        if orderByTime {
            
            sql  += "  ORDER BY inserttime DESC"
            
        }
        
        let array = executeRecordSet(sql: sql)
        
        var result = [Book]()
        
        for dic in array {
            
            
            guard let value = dic["book"] as? String , let data =  value.data(using: .utf8) else {
                
                continue
            }
            
            
            //反序列化data
            guard   let bookArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as?  [String:String]  else {
                
                continue
                
            }
            
            
            let b = Book()
            
            for  (key,value) in bookArray {
                
                b.setValue(value, forKey: key)
            }
            result.append(b)
            
        }
        
        return result
    }
    
    
    
    /// 删除一条或多条记录
    func  deleteBooks(books:[Book],tableName:String,userId:String? = nil, completion: @escaping (_ isSuccess:Bool) -> ()) {
        
        var result = true
        
        var sql = "DELETE FROM \(tableName) WHERE bookid = ?\n"
        
        if userId != nil {
            
            sql += " AND userid = ?"
            
        }
        
        
        queue.inTransaction { (db, rollbacl) in
            
            for book  in books {
                
                guard let bookid = book.bookId  else {
                    
                    continue
                }
                
                var parameters = [Any]()
                
                parameters.append(bookid)
                
                if userId != nil {
                    
                    parameters.append(userId!)
                    
                }
                
                if db?.executeUpdate(sql, withArgumentsIn: parameters) == false {
                    
                    rollbacl?.pointee = true
                    
                    result = false
                    
                    break
                    
                }
            }
            
        }
        
        completion(result)
        
    }
    
    
    ///清空表中的所有数据
    func clearAll(tableName:String,userId:String? = nil, completion: ((_ isSuccess:Bool) -> ())?) {
        
        var reslut = true
        
        var sql = "DELETE FROM \(tableName)\n"
        
        if userId != nil {
            
            sql += "WHERE userid = '\(userId)'"
        }
        
        
        queue.inTransaction { (db, rollbacl) in
            
            if db?.executeUpdate(sql, withArgumentsIn: []) == false {
                
                rollbacl?.pointee = true
                
                reslut = false
                
            }
        }
        
        completion?(reslut)
        
    }
    
    
    
    
    
    
    
    
}





// MARK: - 基础建表，查询操作
extension SoDuSQLiteManager {
    
    
    func executeRecordSet(sql:String) -> [[String: Any]] {
        
        var result = [[String: Any]]()
        
        queue.inTransaction { (db, rollbacl) in
            
            guard let rs =  db?.executeQuery(sql, withArgumentsIn: []) else{
                
                return
                
            }
            
            
            while rs.next() {
                
                var dic : [String:Any] =  [String:Any]()
                
                let colCount = rs.columnCount()
                
                for col in 0..<colCount {
                    
                    guard let name = rs.columnName(for: col) ,let value = rs.object(forColumnIndex: col) else {
                        
                        continue
                    }
                    
                    dic[name] = value
                    
                }
                
                result.append(dic)
            }
            
        }
        
        return result
    }
    
    
    
    func createTable() {
        
        guard let path = Bundle.main.path(forResource: "createtable.sql", ofType: nil),
            
            let sql = try? String(contentsOfFile: path)  else {
                
                return
                
        }
        
        queue.inDatabase { (db) in
            
            if db?.executeStatements(sql) == true {
                
                print("建表成功")
                
            } else {
                
                print("建表失败")
                
            }
        }
        
        
        
        
    }
    
    
    
}


// MARK: - 缓存本地图书的相关数据库操作
extension SoDuSQLiteManager {
    
    
    ///查询图书的目录
    func selectBookCatalogs(bookId:String)-> [BookCatalog] {
        
        let sql = "SELECT bookid,chapterurl,chapterindex,chaptername,chaptercontent FROM  bookcatalog  WHERE bookid = '\(bookId)'"
        
        let array = executeRecordSet(sql: sql)
        
        var catalogs = [BookCatalog]()
        
        for dic in array {
           
            guard let bookid = dic["bookid"] as? String,
                let chapterurl = dic["chapterurl"] as? String ,
                let index = dic["chapterindex"] as? String,
                let chapterindex = Int(index) ,
                let chaptername = dic["chaptername"]  as? String,
                let chaptercontent = dic["chaptercontent"] as? String
                
                else {
                    
                    continue
            }
            
            let bookcatalog = BookCatalog()
            
            bookcatalog.bookId = bookid
            bookcatalog.chapterIndex = chapterindex
            bookcatalog.chapterUrl = chapterurl
            bookcatalog.chapterName = chaptername
            bookcatalog.chapterContent = chaptercontent
            
            catalogs.append(bookcatalog)
            
            
        }
        
        return catalogs
        
    }
    
    ///清空表中的所有数据
    func deleteBookCatalogs(bookId:String, completion: ((_ isSuccess:Bool) -> ())?) {
        
        var result = true
        
        let sql = "DELETE FROM  bookcatalog  WHERE bookid = ?"
        
        
        queue.inTransaction { (db, rollbacl) in
            
            if db?.executeUpdate(sql, withArgumentsIn: [bookId]) == false {
                
                rollbacl?.pointee = true
                
                result = false
                
            }
        }
        
        completion?(result)
        
        
    }
    
    
    /// 插入或者更新目录 一条或多条
    func insertOrUpdateBookCatalogs(catalogs:[BookCatalog], bookid:String,completion: ((_ isSuccess:Bool) ->  ())?) {
        
        var result = true
        
        
        let sql = "INSERT OR REPLACE INTO  bookcatalog (bookid, chapterindex,chapterurl ,chaptername,chaptercontent) VALUES (?,?,?,?,?)"
        
        
        
        queue.inTransaction { (db, rollbacl) in
            
            for catalog  in catalogs {
                
                var parameters = [Any]()
                
                
                guard let chapterUrl = catalog.chapterUrl ,let chapterName = catalog.chapterName,let chapterContent = catalog.chapterContent else {
                    
                    continue
                }
                
                let chapterindex = String(catalog.chapterIndex)
                
                parameters.append(bookid)
                parameters.append(chapterindex)
                parameters.append(chapterUrl)
                parameters.append(chapterName)
                parameters.append(chapterContent)
                
                
                if db?.executeUpdate(sql, withArgumentsIn: parameters) == false {
                    
                    rollbacl?.pointee = true
                    
                    result = false
                    
                    break
                    
                }
            }
            
        }
        
        completion?(result)
        
    }
    
    
}



