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


// MARK: - 书架的操作
extension SoDuSQLiteManager {
    
    
    /// 插入或者更新一条书架记录
    func insertOrUpdateBookInBookShelf(userId:String,book:Book) {
        
        
        
        
    }
    
    
    /// 删除一条书架记录
    func  deleteBookInBookShelf(userId:String,book:Book) {
        
        
        
        
    }
    
    
    ///删除所有的书架记录
    func clearAlBookInBookShelf(userId:String) {
        
        
        
    }
    
    
}


// MARK: - 对历史记录的操作
extension SoDuSQLiteManager {
    
    
    /// 插入或者更新一条历史记录
    func insertOrUpdateHistory(book:Book,completion :@escaping (_ isSuccess:Bool) -> ()) {
        
        let sql = "INSERT OR REPLACE INTO  history (bookid ,book) VALUES (?,?);"
        
        queue.inTransaction { (db, rollbacl) in
            
            guard let data = try? JSONSerialization.data(withJSONObject:book.toJSONModel() as Any , options: []) ,let bookid = book.bookId  else {
                
                return
            }
            
            if db?.executeUpdate(sql, withArgumentsIn: [bookid,data]) == false {
                
                rollbacl?.pointee = true
                
                completion(false)
                
            } else {
                
                completion(true)
            }
            
        }
        
    }
    
    
    /// 删除一条历史记录
    func  deleteHistory(book:Book,completion: @escaping (_ isSuccess:Bool) -> ()) {
        
        var sql = "DELETE FROM history WHERE bookid = "
       
        guard let bookid = book.bookId  else {
            
            return
        }
        
        sql += "'"
        
        sql += bookid
        
        sql += "'"
        
        queue.inTransaction { (db, rollbacl) in
            
            if db?.executeUpdate(sql, withArgumentsIn: []) == false {
                
                rollbacl?.pointee = true
                
                completion(false)
                
            } else {
                
                completion(true)
            }
            
        }
        
        
        
    }
    
    
    ///删除所有的历史记录
    func clearAllHistory() {
        
        
        
    }
    
    
    func selectHistory() -> [Book] {
        
        let sql = "SELECT  bookid, book FROM history;"
        
        let array = executeRecordSet(sql: sql)
        
        var result = [Book]()
        
        for dic in array {
            
            guard let value = dic["book"]  as? Data else {
                
                continue
            }
            
            
            //反序列化data
            guard   let bookArray = try? JSONSerialization.jsonObject(with: value, options: []) as?  [String:String]  else {
                
                continue
                
            }
            
            if bookArray != nil {
                
                let b = Book()
                
                for  (key,value) in bookArray! {
                    
                    b.setValue(value, forKey: key)
                }
                result.append(b)
                
            }
            
        }
        
        return result
    }
    
    
    
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
    
    
}





extension SoDuSQLiteManager {
    
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



