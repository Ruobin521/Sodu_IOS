//
//  LocalBookItemViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/11.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import Foundation



class LocalBookItemViewModel : NSObject{
    
    var hasUpdate = false
    
    var updateData:String = ""
    
    var book:Book!
    
    var updateCompletion :(() -> ())?
    
    var setContentBlock :(() -> ())?
    
    var checkUpdateCompletion:((_ data:String)->())?
    
    var needUpdateCatalogs : [BookCatalog]?
    
    var isUpdating = false
}

extension LocalBookItemViewModel {
    
    
    func checkUpdate(completion:(()->())?) {
        
        DispatchQueue.global().async {
            
            let localCatalogs = SoDuSQLiteManager.shared.selectBookCatalogs(bookId: self.book.bookId!)
            
            var loacalLastcatalog:BookCatalog?
            
            if localCatalogs.count == 0 {
                
                loacalLastcatalog = nil
                
            }
            
            guard let url = self.book.LastReadContentPageUrl else {
                
                completion?()
                return
            }
            
            guard  let catalogPageUrl = AnalisysHtmlHelper.AnalisysHtml(url,"", AnalisysType.CatalogPageUrl) as? String else {
                
                completion?()
                return
            }
            
            DispatchQueue.main.async {
                
                self.checkUpdateCompletion?("检测更新...")

            }
            
            
            guard  let webCatalogs = self.getBookCatalogs(url: catalogPageUrl) else {
                
                completion?()
                
                self.checkUpdateCompletion?("")
                
                return
            }
            
            if webCatalogs.count == 0 {
                
                completion?()
                 self.checkUpdateCompletion?("")
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
                    
                    completion?()
                    self.checkUpdateCompletion?("")
                    return
                    
                }
                
                index = tempIndex
            }
            
            
            
            
            if index == webCatalogs.count - 1 {
                
                completion?()
                self.checkUpdateCompletion?("")
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
                
                self.checkUpdateCompletion?(String(updateCount))
                
                self.hasUpdate = true
                
            } else {
                
                self.checkUpdateCompletion?("")
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
        
        DispatchQueue.global().async {
            
            var count = 0
            
            for item in  self.needUpdateCatalogs! {
                
                count += 1
                
                guard let url = item.chapterUrl else {
                    
                    continue
                }
                
                item.chapterContent = CommonPageViewModel.getCatalogContent(urlString: url,bookName:self.book.bookName)
                
                self.checkUpdateCompletion?(String(self.needUpdateCatalogs!.count - count))
                
            }
            
            self.insertToDB()
            
        }
        
    }
    
    
    
    func insertToDB() {
        
        SoDuSQLiteManager.shared.insertOrUpdateBookCatalogs(catalogs: self.needUpdateCatalogs!, bookid: (self.book?.bookId)!) { (isSuccess) in
            
            if isSuccess {
                
                
                self.book?.isLocal = "1"
                
                SoDuSQLiteManager.shared.insertOrUpdateBooks(books: [self.book!], tableName: TableName.Loaclbook.rawValue, completion: { (isSuccess) in
                    
                    self.updateCompletion?()
                    
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
