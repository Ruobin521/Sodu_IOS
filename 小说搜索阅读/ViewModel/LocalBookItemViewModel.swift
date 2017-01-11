//
//  LocalBookItemViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/11.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import Foundation



class LocalBookItemViewModel {
    
    var hasUpdate = false
    
    var book:Book!
    
    var updateCompletion :(() -> ())?
    
    var checkUpdateCompletion:((_ count:Int)->())?
    
}

extension LocalBookItemViewModel {
    
    
    func checkUpdate(completion:(()->())?) {
        
        DispatchQueue.global().async {
            
            let localCatalogs = SoDuSQLiteManager.shared.selectBookCatalogs(bookId: self.book.bookId!)
            
            if localCatalogs.count == 0 {
                
                completion?()
                return
            }
            
            guard let loacalLastcatalog = localCatalogs.last ,let url = loacalLastcatalog.chapterUrl  else{
              
                completion?()
                return
            }
            
            
            guard  let catalogPageUrl = AnalisysHtmlHelper.AnalisysHtml(url,"", AnalisysType.CatalogPageUrl) as? String else {
                
                completion?()
                return
            }
            
            
            guard  let webCatalogs = self.getBookCatalogs(url: catalogPageUrl) else {
              
                completion?()
                return
            }
            
            if webCatalogs.count == 0 {
               
                completion?()
                return
            }
            
            guard let tempCatalog = webCatalogs.first(where: { (item) -> Bool in
                
                loacalLastcatalog.chapterUrl == item.chapterUrl
                
            }) else{
               
                completion?()
                return
            }
            
            guard let index = webCatalogs.index(of: tempCatalog) else {
               
                completion?()
                return
            }
            
            if index == webCatalogs.count - 1 {
               
                completion?()
                return
            }
            
            let updateCount = webCatalogs.count - 1 - index
            
            
            self.checkUpdateCompletion?(updateCount)
            
            completion?()
        }
        
    }
    
    
    
    
    func downLoadUpdate() {
        
        
        
        
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
                
                catalogs = values.catalogs
                
                break
                
            }
            
        }
        
        return catalogs
    }
    
    
}
