
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeDownloadItem), name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: nil)
        
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
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
}

extension DownloadCenterPageViewModel {
    
    
    func addDownloadItem(book:Book) {
        
        
        if  let _ = bookList.first(where: { (temp) -> Bool in
            
            temp.book!.bookId == book.bookId
            
        }) {
            
            ToastView.instance.showGlobalToast(content: "\(book.bookName!)已存在于缓存队列中",true,true)
            
            return
        }
        
        
        let books =  SoDuSQLiteManager.shared.selectBook(tableName: TableName.Loaclbook.rawValue)
        
        if let _  = books.first(where: { (temp) -> Bool in
            
            temp.bookId == book.bookId
            
        }) {
            
            ToastView.instance.showGlobalToast(content: "\(book.bookName!)已经存在于本地图书列表中",true,true)
            return
            
        }
        
        let item = DownLoadItemViewModel(book: book.clone())
        
        item.startDowm()
        
        bookList.append(item)
        
        ToastView.instance.showGlobalToast(content: "开始缓存，您可在”设置-下载中“查看进度",true,true)
        
        
    }
    
    
    
    
}
