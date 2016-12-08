//
//  DownLoadItemViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/8.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class DownLoadItemViewModel {
    
    var book:Book?
    
    var totalCount:Int = 0
    
    var downloadedCount:Int = 0
    
    
    var timer : Timer?
    
    var processValue :Float = 0
    
    var isCompleted:Bool = false
    
    
    init(book:Book) {
        
        self.book = book
        
        totalCount = (book.catalogs?.count)!
      
        
    }
    
    
    
    func startDowm() {
        
        // let catalogs = book?.catalogs
        
        var catalogGroup = [[BookCatalog]]()
        
        for i in 0..<(book?.catalogs?.count)! {
            
            let index = i % 15
            
            if catalogGroup.count < index + 1 {
                
                catalogGroup.append([BookCatalog]())
            }
            
            catalogGroup[index].append((self.book?.catalogs)![i])
            
        }
        
        //创建并行队列
        let concurrent = DispatchQueue(label: "concurrentQueue1", attributes: .concurrent)
        
        
        let group = DispatchGroup()
        
        
        for catalogs in catalogGroup {
            
            concurrent.async(group: group) {
                
                for catalog in catalogs {
                    
                    guard let url = catalog.chapterUrl else {
                        
                        continue
                    }
                    
                    catalog.chapterContent =  self.httpRequest(urlString: url)
                    print("\(catalog.chapterName!)下载完成")
                    self.downloadedCount += 1
                    
                }
                
            }
            
        }
        
        group.notify(queue: concurrent) {
            
            self.insertToDB()
            
        }
        
    }
    
    
    func httpRequest(urlString:String) -> String? {
        
        var result:String? = nil
        //创建NSURL对象
        let url:URL! = URL(string: urlString)
        //创建请求对象
        let urlRequest:URLRequest = URLRequest(url: url)
        //响应对象
        var response:URLResponse?
        
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        do {
            
            if  let data:Data =  try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: &response) as Data? {
                
                guard  let  str = String(data: data , encoding: String.Encoding(rawValue: enc)) else {
                    
                    return nil
                }
                
                guard let htmlValue = AnalisysHtmlHelper.AnalisysHtml(urlString, str,AnalisysType.Content) as? String  else{
                    
                    return nil
                }
                
                result = htmlValue
            }
            
        }catch {
            
            return nil
        }
        
        return result
    }
    
}


extension DownLoadItemViewModel {
    
    
    func insertToDB() {
        
        //建表 
        
        SoDuSQLiteManager.shared.createBookTable(withTableName: (book?.bookId)!)
        
        SoDuSQLiteManager.shared.insertOrUpdateBookCatalogs(catalogs: (self.book?.catalogs)!, withTableName: (self.book?.bookId)!) { (isSuccess) in
            
            if isSuccess {
                
                self.isCompleted = true
            }
            
        }
    }
    
    
    
    
}
