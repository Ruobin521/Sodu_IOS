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
    
    //显示部分
    let  moonlightBackColor:UIColor = #colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.04705882353, alpha: 1)
    
    let  moonlightForegroundColor:UIColor = #colorLiteral(red: 0.3529411765, green: 0.3529411765, blue: 0.3529411765, alpha: 1)
    
    
    var  daylightBackColor:UIColor = UIColor.colorWithHexString(hex: ViewModelInstance.Instance.Setting.contentBackColor) {
        
        didSet {
            
            //  ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentBackColor, daylightBackColor.cgColor)
            
        }
        
    }
    
    
    var  daylightForegroundColor:UIColor =  UIColor.colorWithHexString(hex: ViewModelInstance.Instance.Setting.contentTextColor) {
        
        didSet {
            
            // ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentTextSize, fontSize)
            
        }
        
    }
    
    
    
    var fontSize:Float = ViewModelInstance.Instance.Setting.contentTextSize   {
        
        didSet {
            
            ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentTextSize, fontSize)
            
        }
        
    }
    
    
    
    var lineSpace:Float = ViewModelInstance.Instance.Setting.contentLineSpace  {
        
        didSet {
            
            ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentLineSpace, lineSpace)
            
        }
        
    }
    
    
    
    var isMoomlightMode =  ViewModelInstance.Instance.Setting.isMoomlightMode {
        
        didSet {
            
            ViewModelInstance.Instance.Setting.setValue(SettingKey.IsMoomlightMode, isMoomlightMode)
            
        }
        
    }
    
    
    //数据部分
    
    var catalogsRetryCount = 0
    
    var isRequestContent = false
    var isRequestCatalogs = false
    
    
    var currentChapterPageList:[String]?
    
    var preChapterPageList:[String]?
    
    var nextChapterPageList:[String]?
    
    //    var curentChapterText:String?
    //
    //    var preChapterText:String?
    //
    //    var nextChapterText:String?
    
    let topMargin:Float = 30
    
    let leftMargin:Float = 15
    
    let rightMargin:Float = 8
    
    let bottonMargin:Float = 30
    
    
    var currentCatalog:BookCatalog?
    
    var currentBook:Book?  {
        
        didSet {
            
            currentCatalog = BookCatalog(currentBook?.bookId, currentBook?.chapterName, currentBook?.contentPageUrl, nil)
            
        }
    }
    
    
    func getCuttentChapterContent(_ url:String,_ completion:@escaping (_ isSuccess:Bool)->())  {
        
        getContentByUrl(url) { (isSuccess, strs) in
            
            if isSuccess {
                
                self.currentChapterPageList = strs
                
            }
            
            completion(isSuccess)
        }
    }
    
    
    
    func getPreCatalogContent(_ url:String,_ completion:@escaping (_ isSuccess:Bool)->()) {
        
        
        getContentByUrl("") { (isSuccess, strs) in
            
            if isSuccess {
                
                self.preChapterPageList = strs
                
            }
            
            completion(isSuccess)
            
        }
    }
    
    
    func getNextCatalogContent(_ url:String,_ completion:@escaping (_ isSuccess:Bool)->()) {
        
        
        getContentByUrl("") { (isSuccess, strs) in
            
            if isSuccess {
                
                self.preChapterPageList = strs
                
            }
            completion(isSuccess)
        }
    }
    
    
    
    func getContentByUrl(_ url:String,_ retryCount:Int = 0,_ completion:@escaping (_ isSuccess:Bool,_ html:[String]?)->())  {
        
        self.isRequestContent = true
        
        var count = retryCount
        
        CommonPageViewModel.getHtmlByURL(url: url) {[weak self] (isSuccess, html) in
            
            if isSuccess {
                
                let  htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.Content) as? String
                
                count = 0
                
                self?.isRequestContent = false
                
                print("获取\(url)正文成功")
                
                completion(true,self?.splitPages(str: htmlValue!))
                
            }  else {
                
                count += 1
                
                if count  == 4  {
                    
                    count = 0
                    
                    completion(false,nil)
                    
                } else {
                    
                    self?.getContentByUrl(url,count,completion)
                    
                    print("获取\((self?.currentBook?.bookName) ?? " ")正文失败，正在进行第\(count)次尝试")
                    
                }
                
            }
            
        }
    }
    
    
    func getBookCatalogs(url:String,completion: ((_ isSuccess:Bool)->())?)  {
        
        
        self.isRequestCatalogs = true
        
        guard  let bookid = self.currentBook?.bookId else {
            
            self.catalogsRetryCount = 0
            
            completion?(false)
            
            self.isRequestCatalogs = false
            
            return
            
        }
        
        CommonPageViewModel.getBookCIAC(url: url, bookid: bookid) { [weak self] (isSuccess, value:Any?) in
            
            if isSuccess {
                
                let result = value as? (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)
                
                self?.currentBook?.catalogs = result?.catalogs
                
                self?.currentBook?.introduction = result?.introduction
                
                self?.currentBook?.coverImage = result?.cover
                
                self?.currentBook?.author = result?.author
                
                self?.isRequestCatalogs = false
                
                self?.catalogsRetryCount = 0
                
                print("获取\(self?.currentBook?.bookName ?? " ")目录成功")
                
            } else {
                
                self?.catalogsRetryCount += 1
                
                self?.isRequestCatalogs = false
                
                if self?.catalogsRetryCount  == 4 {
                    
                    completion?(false)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，不再尝试，无解。")
                    
                    
                } else {
                    
                    self?.getBookCatalogs(url: url, completion: completion)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，正在进行第\(self?.catalogsRetryCount  ?? -1)次尝试")
                    
                }
            }
        }
        
    }
}


extension BookContentPageViewModel {
    
    
    /// 设置正文显示属性
    func  getTextContetAttributes() -> [String:Any]  {
        
        var  dic:[String:Any] = [:]
        
        // dic[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: CGFloat(vm.fontSize))
        dic[NSFontAttributeName] =  UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing =  CGFloat(lineSpace)
        
        dic[NSParagraphStyleAttributeName] = paragraphStyle
        
        
        var color:UIColor!
        
        if isMoomlightMode {
            
            color = moonlightForegroundColor
            
        } else {
            
            color = daylightForegroundColor
        }
        
        dic[NSForegroundColorAttributeName] = color
        
        return dic
    }
    
    
    
    func splitPages(str:String)  -> [String] {
        
        let paragraphes = str.components(separatedBy: "\n")
        
        if paragraphes.count < 2 {
            
            return paragraphes
        }
        
        
        var pages:[String] = [String]()
        
        
        let height = UIScreen.main.bounds.height - 30 - 50
        
        let width = UIScreen.main.bounds.width - 15 - 8
        
        let viewSize = CGSize(width: width, height: height)
        
        let label = UILabel()
        
        label.text = "国国国国"
        
        label.numberOfLines = 0
        
        label.attributedText = NSAttributedString(string: label.text!, attributes: getTextContetAttributes())
        
        var size = label.sizeThatFits(CGSize(width: viewSize.width, height: CGFloat(MAXFLOAT)))
        
        let perlineHeight = size.height
        
        let perTextWidth = size.width / 4
        
        
        //        let rowCount = height.truncatingRemainder(dividingBy:  perlineHeight)  / size.height > 0.8  ? Int(height / perlineHeight) + 1  :Int(height / perlineHeight)
        //
        //        let perLineCount =  width.truncatingRemainder(dividingBy: perTextWidth) / size.width > 0.8  ? Int(width / perTextWidth) + 1  : Int(width / perTextWidth)
        
        
        
        var tempHeight:CGFloat = 0  // 记录临时行高
        
        
        var tempPageContent :String = ""
        
        for j in 0..<paragraphes.count {
            
            let str = paragraphes[j]
            
            label.text = str
            
            label.attributedText = NSAttributedString(string: label.text!, attributes: getTextContetAttributes())
            
            size =  label.sizeThatFits(CGSize(width: viewSize.width, height: CGFloat(MAXFLOAT)))
            
            let num = label.numberOfLines
            
            
        
            
            if tempHeight + size.height < height {
                
                tempHeight += size.height
                
                tempPageContent += str + "\r"
                
            } else {
                
                label.text = ""
                
                for (i,char) in str.characters.enumerated() {
                    
                    var temp = label.text
                    
                    let ch = String(char)
                    
                    label.text = temp! + ch
                    
                    label.attributedText = NSAttributedString(string: label.text!, attributes: getTextContetAttributes())
                    
                    size =  label.sizeThatFits(CGSize(width: viewSize.width, height: CGFloat(MAXFLOAT)))
                    
                    if tempHeight + size.height > height {
                        
                        tempPageContent += temp! + "\r'"
                        
                        pages.append(tempPageContent)
                        
                        tempPageContent = ch
                        
                        temp = ""
                        
                        label.text = ""
                        
                        tempHeight = 0
                        
                    }
                    
                    if i == str.characters.count - 1 {
                        
                        tempPageContent += temp! + "\r'"
                        
                        tempHeight += size.height
                    }
                }
                
                
//                if tempHeight > height {
//                    
//                    pages.append(tempPageContent)
//                    
//                    tempPageContent = ""
//                    
//                    tempHeight = 0
//                    
//                }
                
               
                
            }
            
            
            if j == (paragraphes.count - 1) && !tempPageContent.isEmpty {
                
                pages.append(tempPageContent)
            }
            
        }
        
        return pages
        
    }
    
    
    func isIncludeChineseIn(string: String) -> Bool {
        
        for (_, value) in string.characters.enumerated() {
            
            
            if ("\u{4E00}" <= value  && value <= "\u{9fff}") {
                
                return true
            }
        }
        
        return false
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
