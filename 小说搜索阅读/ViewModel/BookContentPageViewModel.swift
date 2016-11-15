//
//  BookContentPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


class BookContentPageViewModel {
    
    var curentChapterText:String?
    
    var nextChapterText:String?
    
    var preChapterText:String?
    
    
    var fontSize:Float = 20
    
    var lineSpace:Float = 12
    
    
    
    init() {
        
        getSettingValues()
    }
    
    
    
    func getCuttentChapterContent(url:String,completion:@escaping (_ isSuccess:Bool)->())  {
        
        
        getHtmlByURL(url: url) { (isSuccess, html) in
            
            if isSuccess {
                
                self.curentChapterText = html
                
            }
            
            completion(isSuccess)
            
        }
        
    }
    
    
    
    func   getHtmlByURL(url:String,completion:@escaping (_ isSuccess:Bool ,_ html:String?)->())  {
        
        HttpUtil.instance.AFrequest(url: url, requestMethod: .GET, postStr: nil, parameters: nil, timeOut: 30)   { (data,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    completion(false,nil)
                    
                }  else {
                    
                    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                    
                    guard  let  str = String(data: data as! Data, encoding: String.Encoding(rawValue: enc)) else {
                        
                        completion(false,nil)
                        
                        return
                    }
                    
                    guard let htmlValue = AnalisysContentHtmlHelper.AnalisysContentHtml(url, str) else {
                        
                        completion(false,nil)
                        
                        return
                        
                    }
                    
                    completion(true,htmlValue)
                    
                }
                
            }
        }
    }
    
}

extension BookContentPageViewModel {
    
    
    func getSettingValues() {
        
        
//        fontSize = 18
//        lineSpace = 18
        
    }
    
}
