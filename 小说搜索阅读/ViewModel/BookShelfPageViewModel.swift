//
//  BookShelfPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class BookShelfPageViewModel {
    
    lazy var bookList = [Book]()
    
    
    func loadCacheData(_ vc:BaseViewController) {
        
        if bookList.count == 0 {
            
            let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.BookShelf)
            
            if (tempList.count) > 0 {
                
                bookList.removeAll()
                
                bookList += tempList
                
                vc.tableview?.reloadData()
            }
        }
    }
    
    
    func loadBookShelfPageData(completion:@escaping (_ isSuccess:Bool)->()) {
        
        
        let urlStr =  SoDuUrl.homePage
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    ToastView.instance.showToast(content: "个人收藏数据加载失败",false)
                    
                }  else {
                    
                    let array = AnalisysHtmlHelper.analisysBookShelfHtml(html)
                    
                    self.bookList.removeAll()
                    
                    self.bookList += array
                    
                    BookCacheHelper.SavaBookListAsFile(self.bookList, .BookShelf)
                  
                    ToastView.instance.showToast(content: "已加载个人收藏数据")

                    completion(true)
                    
                    
                }
                
            }
            
        }
    }
}
