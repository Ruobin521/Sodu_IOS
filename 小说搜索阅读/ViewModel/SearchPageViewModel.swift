//
//  SearchViewModel.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/20.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class SearchPageViewModel {
    
    lazy var bookList = [Book]()


    
    func loadSearchData(_ searchPar: String,completion:@escaping (_ isSuccess:Bool)->()) {
        
        let urlStr =  SoDuUrl.searchPage + CommonPageViewModel.urlEncode(searchPar) 
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    
                }  else {
                    
                    let array = AnalisysHtmlHelper.analisysSearchHtml(html)
                    
                    self.bookList.removeAll()
                    
                    self.bookList += array
                    
                    completion(true)
                    
                }
                
            }
            
        }
    }


}
