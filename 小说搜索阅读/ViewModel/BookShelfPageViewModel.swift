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
        
        
        let urlStr =  SoDuUrl.bookShelfPage
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    
                }  else {
                    
                    let array = AnalisysHtmlHelper.analisysBookShelfHtml(html)
                    
                    self.bookList.removeAll()
                    
                    self.bookList += array
                    
                    BookCacheHelper.SavaBookListAsFile(self.bookList, .BookShelf)
                    
                    completion(true)
                }
                
            }
        }
    }
    
    
    func removeBookFromList(_ book:Book,indexPath:IndexPath,completion:@escaping (_ isSuccess:Bool)->())  {
        
        HttpUtil.instance.request(url: SoDuUrl.bookShelfPage + "?id=\(book.bookId!)", requestMethod: .GET,postStr:nil,true) { (str, isSuccess) in
            
            
            DispatchQueue.main.async {
                
                if isSuccess && (str?.contains("取消收藏成功"))!{
                    
                    self.bookList.remove(at: indexPath.section)
                    
                    completion(true)
                    
                    
                    
                }  else {
                    
                    
                    completion(false)
                }
                
            }
            
        }
        
    }
}
