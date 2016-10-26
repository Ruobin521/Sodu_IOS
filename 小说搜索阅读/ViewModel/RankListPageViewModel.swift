//
//  RankListPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class RankListPageViewModel {
    
    
    lazy var bookList = [Book]()
    
    let pageCount = 8
    
    var pageIndex = 0
    
    func loadCacheData(_ vc:BaseViewController) {
        
        if bookList.count == 0 && pageIndex == 0 {
            
            let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.Rank)
            
            if (tempList.count) > 0 {
                
                bookList.removeAll()
                
                bookList += tempList
                
                vc.tableview?.reloadData()
            }
        }
    }
    
    
    func loadRankListDataByPageIndex(_ pageindex: Int,completion:@escaping (_ isSuccess:Bool)->()) {
        
        let urlStr =  SoDuUrl.rankPage.replacingOccurrences(of: "_", with: "_\(pageindex + 1)")
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败", false)
                    
                    print("第\(pageindex+1)页数据加载失败")
                    
                   // completion(false)
                    
                }  else {
                    
                    self.pageIndex = pageindex
                    
                    let array = AnalisysHtmlHelper.analisysRankHtml(html)
                    
                    if pageindex == 0 {
                        
                        self.bookList.removeAll()
                        
                        BookCacheHelper.SavaBookListAsFile(array, .Rank)
                    }
                    
                    self.bookList += array
                    
                    ToastView.instance.showToast(content: "已加载排行榜第\(pageindex+1)页数据")
                    
                    completion(true)
                }
                
            }
            
        }
    }
}




