//
//  UpdateChapterViewModel.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class UpdateChapterViewModel {
    
    lazy var chapterList = [Book]()
    
    var currentBook:Book?
    
    var pageIndex = 0
    
    var pageCount = 0
    
    
    func loadUpdateChapterListDataByPageIndex(_ pageindex: Int,completion:@escaping (_ isSuccess:Bool)->()) {
        
        if currentBook == nil {
            
            completion(false)
            
        }
        
        let urlStr = (pageindex == 0 ? currentBook?.updateListPageUrl : currentBook?.updateListPageUrl?.replacingOccurrences(of: ".html", with: "_\(pageindex + 1).html")) ?? ""
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { [weak self]  (html,isSuccess) in
            
            guard let _ = self else {
                
                return
            }
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                                         
                    completion(false)
                    
                }  else {
                    
                    self?.pageIndex = pageindex
                    
                    let array = AnalisysBookListHtmlHelper.analisysUpdateChapterHtml(html)
                    
                    
                    self?.pageCount =  AnalisysBookListHtmlHelper.analisysUpdateChapterPageCount(html)
                    
                    if pageindex == 0 {
                        
                        self?.chapterList.removeAll()
                        
                    }
                    
                    for item  in array {
                        
                        item.bookId = self?.currentBook?.bookId
                        item.bookName = self?.currentBook?.bookName
                    }
                    
                    self?.chapterList += array
                    
                    completion(true)
                    
                }
                
            }
            
        }
    }
    
    
    
}
