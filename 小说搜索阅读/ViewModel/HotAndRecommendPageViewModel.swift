//
//  HotAndRecommendViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class HotAndRecommendPageViewModel {
    
    lazy  var bookList = [Book]()
    
    func loadCacheData(vc:BaseViewController) {
        
        BookListDBHelpr.loadHomeCache(tableName: TableName.Recommend.rawValue, completion: { (isSuccess, tempList) in
            
            if  isSuccess {
                
                if self.bookList.count == 0 {
                    
                    self.bookList.removeAll()
                    
                    self.bookList += tempList!
                    
                    vc.tableview?.reloadData()
                }
            }
        })
        
    }
    
    
    func loadData(completion:@escaping (_ isSuccess:Bool)->()) {
        
        let urlStr =  SoDuUrl.homePage
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    
                    
                }  else {
                    
                    self.bookList.removeAll()
                    
                    let array = AnalisysBookListHtmlHelper.analisysHotHtml(html)
                    self.bookList += array
                    
                    let array2 = AnalisysBookListHtmlHelper.analisysRecommendHtml(html)
                    self.bookList += array2
                    
                    
                    BookListDBHelpr.saveHomeCache(tableName: TableName.Recommend.rawValue, books: self.bookList, completion: nil)
                    
                    completion(true)
                    
                }
                
            }
            
        }
    }
    
}
