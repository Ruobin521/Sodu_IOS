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
    
    var isDeleted:Bool = false
    
    
    var downloadedCount:Int = 0 {
        
        
        didSet {
            
            processValue = Float(downloadedCount) / Float(totalCount)
        }
    }
    
    var isSuspend = false
    
    //创建并行队列
    let concurrent:DispatchQueue!
    
    
    let group = DispatchGroup()
    
    
    var timer : Timer?
    
    var processValue :Float = 0
    
    var isCompleted:Bool = false
    
    
    init(book:Book) {
        
        self.book = book
        
        totalCount = (book.catalogs?.count)!
        
        concurrent = DispatchQueue(label: "concurrentQueue\(book.bookId)", attributes: .concurrent)
    }
    
}



// MARK: - 开始 ，暂停，删除 操作
extension DownLoadItemViewModel {
    
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
        
        
        for catalogs in catalogGroup {
            
            concurrent.async(group: group) {
                
                for catalog in catalogs {
                    
                    if self.isDeleted {
                        
                        break
                    }
                    
                    if let url = catalog.chapterUrl {
                        
                        catalog.chapterContent =  self.httpRequest(urlString: url)
                        print("\(catalog.chapterName!)下载完成")
                    }
                    
                    self.downloadedCount += 1
                    
                }
                
            }
            
        }
        
        group.notify(queue: concurrent) {
            
            if self.isDeleted {
                
                return
            }
            
            self.insertToDB()
            
        }
        
    }
 
    
    // MARK:删除
    func  delete() {
        
        self.isDeleted = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: self.book?.bookId)
        
    }
    
    
}

extension DownLoadItemViewModel {
    
    
    func httpRequest(urlString:String) -> String? {
        
        var result:String? = nil
        //创建NSURL对象
        let url:URL! = URL(string: urlString)
        //创建请求对象
        var urlRequest:URLRequest = URLRequest(url: url)
        //响应对象
        var response:URLResponse?
        
        urlRequest.timeoutInterval = 15
        
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
    
    
    func insertToDB() {
        
        SoDuSQLiteManager.shared.insertOrUpdateBookCatalogs(catalogs: (self.book?.catalogs)!, bookid: (self.book?.bookId)!) { (isSuccess) in
            
            if isSuccess {
                
                self.book?.lastReadChapterName = self.book?.catalogs?[0].chapterName
                self.book?.LastReadContentPageUrl = self.book?.catalogs?[0].chapterUrl
                
                self.book?.isLocal = "1"
                
                SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [self.book!], tableName: TableName.Loaclbook.rawValue, completion: { (isSuccess) in
                    
                    DispatchQueue.main.async {
                        
                        ToastView.instance.showGlobalToast(content: "\((self.book?.bookName)!)下载完成，点击”本地图书“查看",true,true)
                        
                    }
                    
                    let vm = LocalBookItemViewModel()
                    
                    vm.book = self.book!
                    
                    ViewModelInstance.instance.localBook.bookList.insert(vm, at: 0)
                    
                })
                
            } else{
                
                ToastView.instance.showGlobalToast(content: "\((self.book?.bookName)!)下载失败",false)
            }
            
            self.isCompleted = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: self.book?.bookId)
            
        }
    }
    
    
    
    
}
