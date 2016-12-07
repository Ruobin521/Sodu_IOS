
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
    
    
    var bookList:[Book]  = [Book]()
    
    
    
}

extension DownloadCenterPageViewModel {
    
    
    func addDownloadItem(book:Book) {
         
        
        bookList.append(book.clone())
    }
    
    
    
    
}
