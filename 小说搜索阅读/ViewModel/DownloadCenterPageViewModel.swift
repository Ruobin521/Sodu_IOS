
//
//  DownloadCenterPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

/// 下载中心
class DownloadCenterPageViewModel {
    
    
    var bookList:[DownLoadItemViewModel]  = [DownLoadItemViewModel]()
    
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeDownloadItem), name: NSNotification.Name(rawValue: RemoveDownloadItemNotification), object: nil)
 
    }
    
    @objc func removeDownloadItem(obj:Notification) {
        
        guard let bookid = obj.object as? String else {
            
            return
        }
        
        let index = bookList.index { (item) -> Bool in
            
            bookid == item.book?.bookId
            
        }
        
        
        if index != nil {
            
            bookList.remove(at: index!)
           
        }
    }
    
    
}

extension DownloadCenterPageViewModel {
    
    
    func addDownloadItem(book:Book) {
          
        let item = DownLoadItemViewModel(book: book.clone())
       
        item.startDowm()
        
        bookList.append(item)
    }
    
    
    
    
}
