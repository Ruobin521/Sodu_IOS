//
//  LocalBookItemViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/11.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit

class LocalBookItemViewModel : NSObject{
    
    var hasUpdate = false
    
    var updateData:String = ""
    
    var updateValue:CGFloat = 0
    
    var book:Book!
    
    var updateCompletion :(() -> ())?
    
    var setContentBlock :(() -> ())?
    
    var setUpdateDataBlock:(()->())?
    
    var needUpdateCatalogs : [BookCatalog]?
    
    var isUpdating = false
    
    var isDeleted = false
    
    //创建并行队列
    var concurrent:DispatchQueue?
    
    let group = DispatchGroup()
}

extension LocalBookItemViewModel {
    
    
    func checkUpdate(completion:(()->())?) {
        
        if self.book.isLocal != "1" {
            
            updateData = ""
            
            completion?()
            
            return
        }
        
        checkMethod {
            
            completion?()
            
        }
    }
    
    
    func checkMethod(completion:(()->())?) {
        
        
        DispatchQueue.global().async {
            
            let localCatalogs = SoDuSQLiteManager.shared.selectBookCatalogs(bookId: self.book.bookId!)
            
            var loacalLastcatalog:BookCatalog?
            
            if localCatalogs.count == 0 {
                
                loacalLastcatalog = nil
                
                self.book.isLocal = "2"
                
            }
            
            loacalLastcatalog =  localCatalogs.last
            
            guard let url = self.book.LastReadContentPageUrl else {
                
                completion?()
                return
            }
            
            guard  let catalogPageUrl = AnalisysHtmlHelper.AnalisysHtml(url,"", AnalisysType.CatalogPageUrl) as? String else {
                
                completion?()
                return
            }
            
            DispatchQueue.main.async {
                
                self.updateData = "检测更新..."
                self.updateValue = 0
                
                self.setUpdateDataBlock?()
                
            }
            
            guard  let webCatalogs = self.getBookCatalogs(url: catalogPageUrl) else {
                
                self.updateData = ""
                self.updateValue = 0
                
                self.setUpdateDataBlock?()
                completion?()
                
                return
            }
            
            
            if webCatalogs.count == 0 {
                
                self.updateData = ""
                self.updateValue = 0
                
                self.setUpdateDataBlock?()
                completion?()
                
                return
            }
            
            
            let tempCatalog = webCatalogs.first(where: { (item) -> Bool in
                
                loacalLastcatalog?.chapterUrl == item.chapterUrl
                
            })
            
            
            var index:Int = 0
            
            
            
            if tempCatalog == nil {
                
                index = -1
                
            } else  {
                
                guard let tempIndex = webCatalogs.index(of: tempCatalog!) else {
                    
                    
                    self.updateData = ""
                    self.updateValue = 0
                    
                    self.setUpdateDataBlock?()
                    completion?()
                    
                    return
                    
                }
                
                index = tempIndex
            }
            
            
            
            
            if index == webCatalogs.count - 1 {
                
                self.updateData = ""
                self.updateValue = 0
                
                self.setUpdateDataBlock?()
                completion?()
                
                return
                
            }
            
            let updateCount = webCatalogs.count - 1 - index
            
            if updateCount > 0 {
                
                self.book.chapterName = webCatalogs.last?.chapterName
                
                self.book.chapterUrl = webCatalogs.last?.chapterUrl
                
                
                self.needUpdateCatalogs = [BookCatalog]()
                
                for i in index + 1 ..< webCatalogs.count {
                    
                    self.needUpdateCatalogs?.append(webCatalogs[i])
                    
                }
                
                self.updateData = String(updateCount)
                self.updateValue = 0
                self.setUpdateDataBlock?()
                
                self.hasUpdate = true
                
            } else {
                
                self.updateData = ""
                self.updateValue = 0
                self.setUpdateDataBlock?()
                
            }
            
            
            completion?()
        }
        
        
    }
    
    
    func downLoadUpdate(completion:(()->())?) {
        
        if  isUpdating {
            
            completion?()
            
            return
        }
        
        isUpdating = true
        
        if  needUpdateCatalogs == nil || needUpdateCatalogs?.count == 0 {
            
            return
        }
        
        var count = 0
        
        var catalogGroup = [[BookCatalog]]()
        
        for i in 0..<(needUpdateCatalogs)!.count {
            
            let index = i % 15
            
            if catalogGroup.count < index + 1 {
                
                catalogGroup.append([BookCatalog]())
            }
            
            catalogGroup[index].append((needUpdateCatalogs)![i])
            
        }
        
        concurrent = DispatchQueue(label: "concurrentQueue\(book.bookId)", attributes: .concurrent)
        
        for catalogs in catalogGroup {
            
            concurrent?.async(group: group) {
                
                for catalog in catalogs {
                    
                    if self.isDeleted {
                        
                        break
                    }
                    
                    count += 1
                    
                    if let url = catalog.chapterUrl {
                        
                        catalog.chapterContent =  CommonPageViewModel.getCatalogContent(urlString: url,bookName: self.book?.bookName)
                        print("本地缓存:" + (self.book!.bookName)! +  "-:"  + catalog.chapterName!)
                    }
                    
                    self.updateData = String(self.needUpdateCatalogs!.count - count)
                    
                    self.updateValue =   CGFloat(integerLiteral: count) /  CGFloat(integerLiteral: self.needUpdateCatalogs!.count) *  CGFloat(100.0)
                    
                    self.setUpdateDataBlock?()
                    
                }
            }
            
        }
        
        group.notify(queue: concurrent!) {
           
            self.updateData = ""
            self.updateValue = 0
            self.setUpdateDataBlock?()
            
            if self.isDeleted {
                
                return
            }
            
            self.insertCatalogsToDB()
            
        }
        
        
    }
    
    
    
    func insertCatalogsToDB() {
        
        SoDuSQLiteManager.shared.insertOrUpdateBookCatalogs(catalogs: self.needUpdateCatalogs!, bookid: (self.book?.bookId)!) { (isSuccess) in
            
            if isSuccess {
                
                let temp  =  self.book?.clone()
                
                temp?.isLocal = "1"
                
                SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [temp!], tableName: TableName.Loaclbook.rawValue, completion: { (isSuccess) in
                    
                    if isSuccess {
                        
                        self.book?.isLocal = "1"
                        
                        self.updateCompletion?()
                        
                        self.needUpdateCatalogs?.removeAll()
                        
                        self.updateData = ""
                        
                    }
                    
                })
                
            } else{
                
                
                
            }
            
            self.isUpdating =  false
            
        }
    }
    
    
    
    
    func getBookCatalogs(url:String) -> [BookCatalog]? {
        
        var i = 0 ;
        
        var catalogs :[BookCatalog]?
        
        while  i < 3 {
            
            let html = HttpUtil.instance.httpRequest(urlString: url)
            
            if html != nil {
                
                guard let values = AnalisysHtmlHelper.AnalisysHtml(url, html!, .CatalogList) as? (catalogs:[BookCatalog]?, introduction:String?,authorName:String?, cover:String?) else {
                    
                    i += 1
                    
                    continue
                }
                
                guard let result = values.catalogs  else{
                    
                    i += 1
                    
                    continue
                }
                
                for item in result {
                    
                    item.bookId = book.bookId
                    
                }
                
                if  self.book.introduction == nil || self.book.coverImage == nil  || self.book.author == nil {
                    
                    self.book.introduction = values.introduction
                    
                    self.book.coverImage = values.cover
                    
                    self.book.author = values.authorName
                    
                    SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [self.book!], tableName: TableName.Loaclbook.rawValue, completion: { (isSuccess) in
                        
                        self.setContentBlock?()
                        
                    })
                    
                    
                }
                
                
                
                catalogs = result
                
                break
                
            }
            
        }
        
        return catalogs
    }
    
    
}
