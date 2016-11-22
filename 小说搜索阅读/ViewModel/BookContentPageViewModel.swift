//
//  BookContentPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit

class BookContentPageViewModel {
    
    var curentChapterText:String?
    
    var nextChapterText:String?
    
    var preChapterText:String?
    
    var currentBook:Book?
    
    
    let  moonlightBackColor:UIColor = #colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.04705882353, alpha: 1)
    
    let moonlightForegroundColor:UIColor = #colorLiteral(red: 0.3529411765, green: 0.3529411765, blue: 0.3529411765, alpha: 1)
    
    let  daylightBackColor:UIColor = #colorLiteral(red: 0.6666666667, green: 0.7725490196, blue: 0.6666666667, alpha: 1)
    
    let  daylightForegroundColor:UIColor =  #colorLiteral(red: 0.1058823529, green: 0.2392156863, blue: 0.1450980392, alpha: 1)
    
    
    var fontSize:Float = 20
    
    var lineSpace:Float = 10
    
    var isMoomlightMode = false {
        
        didSet {
            
            ViewModelInstance.Instance.Setting.setValue(SettingKey.IsMoomlightMode, isMoomlightMode)
            
        }
        
    }
    
    init() {
        
        getSettingValues()
    }
    
    
    
    func getCuttentChapterContent(url:String,completion:@escaping (_ isSuccess:Bool)->())  {
        
        
        CommonPageViewModel.getHtmlByURL(url: url) { (isSuccess, html) in
            
            if isSuccess {
                
                guard let contentHtml = html ,let  htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, contentHtml,AnalisysType.Content) as? String else {
                    
                    completion(false)
                    
                    return
                    
                }
                
                self.curentChapterText = htmlValue
                
            }
            
            completion(isSuccess)
            
        }
        
    }
    
    
    func getBookCatalogs(url:String?,completion:@escaping (_ isSuccess:Bool)->())  {
        
        
        guard  let catalogUrl = url,  let catalogPageUrl = AnalisysHtmlHelper.AnalisysHtml(catalogUrl,"", AnalisysType.CatalogPageUrl) as? String else {
            
            completion(false)
            
            return
        }
        
        
        CommonPageViewModel.getHtmlByURL(url: catalogPageUrl) { (isSuccess, html) in
            
            if isSuccess {
                
                guard let _ = AnalisysHtmlHelper.AnalisysHtml(catalogUrl, html!,AnalisysType.CatalogList) as? ([Book], String, String) else {
                    
                    completion(false)
                    
                    return
                    
                }
                
            }
            
            completion(isSuccess)
            
            
            
        }
        
    }
}

extension BookContentPageViewModel {
    
    
    func getSettingValues() {
        
        
        //        fontSize = 18
        //        lineSpace = 18
        
        
        isMoomlightMode = ViewModelInstance.Instance.Setting.isMoomlightMode
        
    }
    
}
