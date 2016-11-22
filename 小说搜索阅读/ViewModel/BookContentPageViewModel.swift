//
//  BookContentPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


class BookContentPageViewModel {
    
    var curentChapterText:String?
    
    var nextChapterText:String?
    
    var preChapterText:String?
    
    var currentBook:Book?
    
    
    
    var fontSize:Float = 20
    
    var lineSpace:Float = 10
    
    
    
    init() {
        
        getSettingValues()
    }
    
    
    
    func getCuttentChapterContent(url:String,completion:@escaping (_ isSuccess:Bool)->())  {
        
        
        CommonPageViewModel.getHtmlByURL(url: url) { (isSuccess, html) in
            
            if isSuccess {
                
                guard let htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.Content) else {
                    
                    completion(false)
                    
                    return
                    
                }
                
                self.curentChapterText = htmlValue
                
            }
            
            completion(isSuccess)
            
        }
        
    }
    
    
    func getBookCatalogs(url:String,completion:@escaping (_ isSuccess:Bool)->())  {
        
        
      //  let catalogPageUrl = ""
        
        
        CommonPageViewModel.getHtmlByURL(url: url) { (isSuccess, html) in
            
            if isSuccess {
                
//                guard let htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.CatalogPageUrl) else {
//                    
//                    completion(false)
//                    
//                    return
//                    
//                }
                
                
            }
            
            completion(isSuccess)
            
        }
        
    }
    
    
    
    
    
    
}

extension BookContentPageViewModel {
    
    
    func getSettingValues() {
        
        
        //        fontSize = 18
        //        lineSpace = 18
        
    }
    
}
