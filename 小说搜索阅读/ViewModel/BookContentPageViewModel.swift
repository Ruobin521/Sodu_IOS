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
    
    
    let  daylightBackColor:UIColor = UIColor.colorWithHexString(hex: ViewModelInstance.Instance.Setting.contentBackColor)
    
    let  daylightForegroundColor:UIColor =  UIColor.colorWithHexString(hex: ViewModelInstance.Instance.Setting.contentTextColor)
    
    
    var fontSize:Float = ViewModelInstance.Instance.Setting.contentTextSize
    
    var lineSpace:Float = ViewModelInstance.Instance.Setting.contentLineSpace
    
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
                
                guard let _ = AnalisysHtmlHelper.AnalisysHtml(catalogUrl, html!,AnalisysType.CatalogList) as? (catalogs:[BookCatalog], introduction:String, cover:String) else {
                    
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

extension UIColor {
    
    /**
     Make color with hex string
     - parameter hex: 16进制字符串
     - returns: RGB
     */
    static func colorWithHexString (hex: String) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
