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
        
        let urlStr = (pageindex == 0 ? currentBook?.updateListPageUrl : currentBook?.updateListPageUrl?.replacingOccurrences(of: ".html", with: "_\(pageindex + 1).html")) ?? ""
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败", false)
                    
                    print("第\(pageindex+1)页数据加载失败")
                    
                    completion(false)
                    
                }  else {
                    
                    self.pageIndex = pageindex
                    
                    let array = AnalisysHtmlHelper.analisysUpdateChapterHtml(html)
                    
                    
                    self.pageCount =  AnalisysHtmlHelper.analisysUpdateChapterPageCount(html)
                    
                    if pageindex == 0 {
                        
                        self.chapterList.removeAll()
                        
                    }
                    
                    for item  in array {
                        
                        item.bookId = self.currentBook?.bookId
                        item.bookName = self.currentBook?.bookName
                    }
                    
                    self.chapterList += array
                    
                    completion(true)
                    
                    let bookName  = (self.currentBook?.bookName)!
                    ToastView.instance.showToast(content: "已加载\(bookName)更新列表第\(pageindex+1)页数据")
                }
                
            }
            
        }
    }
    
    
    
}
