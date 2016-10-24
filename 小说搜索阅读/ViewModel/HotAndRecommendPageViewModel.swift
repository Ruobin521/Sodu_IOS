//
//  HotAndRecommendViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

class HotAndRecommendPageViewModel {
    
    lazy  var hotBookList = [Book]()
    
    lazy  var recommendBookList = [Book]()
    
    
    func loadCacheData(vc:BaseViewController) {
        
        if hotBookList.count == 0  && recommendBookList.count == 0 {
            
            let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.Hot)
            
            if (tempList.count) > 0 {
                
                hotBookList += tempList
            }
            
            let  tempList2 =  BookCacheHelper.ReadBookListCacheFromFile(ListType.Recommend)
            
            if (tempList2.count) > 0 {
                
                recommendBookList += tempList2
            }
            
            vc.tableview?.reloadData()
        }
    }
    
    
    func loadData(completion:@escaping (_ isSuccess:Bool)->()) {
        
        let urlStr =  SoDuUrl.homePage
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false)
                    
                }  else {
                    
                    let array = AnalisysHtmlHelper.analisysHotHtml(html)
                    BookCacheHelper.SavaBookListAsFile(array, .Hot)
                    self.hotBookList.removeAll()
                    self.hotBookList += array
                    
                    let array2 = AnalisysHtmlHelper.analisysRecommendHtml(html)
                    BookCacheHelper.SavaBookListAsFile(array2, .Recommend)
                    self.recommendBookList.removeAll()
                    self.recommendBookList += array2
                    
                    completion(true)
                    
                }
                
            }
            
        }
    }
    
}
