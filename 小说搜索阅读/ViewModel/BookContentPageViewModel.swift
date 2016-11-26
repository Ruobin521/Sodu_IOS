//
//  BookContentPageViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit

enum CatalogPosion {
    
    case Before
    
    case Current
    
    case Next
}

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
    
    var currentBook:Book?  {
        
        didSet {
            
            currentCatalog = BookCatalog(currentBook?.bookId, currentBook?.chapterName, currentBook?.contentPageUrl, nil)
            
        }
    }
    
    var preCatalog:BookCatalog?
    
    var nextCatalog:BookCatalog?
    
    var currentCatalog:BookCatalog? {
        
        didSet {
            //切换到下一章
            if currentCatalog?.chapterUrl == nextCatalog?.chapterUrl {
                
                preChapterPageList = currentChapterPageList
                
                currentChapterPageList = nextChapterPageList
 
            }
                /// 切换到上一章
            else  if currentCatalog?.chapterUrl == preCatalog?.chapterUrl{
                
                nextChapterPageList = currentChapterPageList
                
                currentChapterPageList = preChapterPageList
            }
                ///随机点的章节
            else {
                
                nextChapterPageList = nil
                preChapterPageList = nil
                
            }
             
            
            if currentBook?.catalogs != nil && (currentBook?.catalogs?.count)! > 0 {
                
                setBeforeAndNextCatalog()
                
                if nextChapterPageList == nil {
                    
                    getCatalogChapterContent(posion: .Next, nil)
                    
                }
                
                if preChapterPageList == nil {
                    
                    getCatalogChapterContent(posion: .Before, nil)
                    
                }
                
            }
        }
        
    }
    
    
    
    func  setBeforeAndNextCatalog() {
        
        if currentBook?.catalogs != nil && (currentBook?.catalogs?.count)! > 0 {
            
            preCatalog = getBeforeOrNextCatalog(posion: .Before)
            
            nextCatalog = getBeforeOrNextCatalog(posion: .Next)
        }
        
    }
    
    //获取相应目录内容
    func getCatalogChapterContent(posion:CatalogPosion,_ completion: ((_ isSuccess:Bool)->())?)  {
        
        
        var catalog:BookCatalog?
        
        if posion == .Current {
            
            catalog = currentCatalog
            
        }    else if posion == .Before {
            
            catalog = preCatalog
            
        }   else  {
            
            catalog = nextCatalog
            
        }
        
        guard let url = catalog?.chapterUrl else{
            
            completion?(false)
            
            return
        }
        
        getContentByUrl(url) { (isSuccess, strs) in
            
            if isSuccess {
                
                if posion == .Current {
                    
                    self.currentChapterPageList = strs
                    
                }    else if posion == .Before {
                    
                    self.preChapterPageList = strs
                    
                }   else   if posion == .Next {
                    
                    self.nextChapterPageList = strs
                    
                }
                
            }
            
            completion?(isSuccess)
        }
    }
    
    /// 获取正文内容
    func getContentByUrl(_ url:String,_ retryCount:Int = 0,_ completion:@escaping (_ isSuccess:Bool,_ html:[String]?)->())  {
        
        self.isRequestContent = true
        
        var count = retryCount
        
        CommonPageViewModel.getHtmlByURL(url: url) {[weak self] (isSuccess, html) in
            
            if isSuccess {
                
                if  let  htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.Content) as? String {
                    
                    count = 0
                    
                    self?.isRequestContent = false
                    
                    print("获取\(url)正文成功")
                    
                    completion(true,self?.splitPages(str: htmlValue))
                    
                } else {
                    
                    completion(false,nil)
                }
                
                
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
    
    /// 获取目录列表
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
                
                self?.setBeforeAndNextCatalog()
                
                self?.getCatalogChapterContent(posion: .Next, nil)
                
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
    
    
    //获取上一个章节 和下一章节信息
    func getBeforeOrNextCatalog(posion:CatalogPosion) -> BookCatalog? {
        
        guard let catalogs = currentBook?.catalogs ,let catalog = currentCatalog else {
            
            return nil
        }
        
   
        guard  let currentIndex = getCatalogIndex(catalog)  else {
            
            return nil
            
        }
        
        
        var requestIndex = 0
        
        if posion == .Before {
            
            requestIndex = currentIndex - 1
            
        } else {
            
            
            requestIndex = currentIndex + 1
        }
        
        if requestIndex > 0 && requestIndex < catalogs.count  {
            
            return catalogs[requestIndex]
            
        }
        
        
        return nil
        
    }
    
    
    func getCatalogIndex(_ catalog:BookCatalog) ->Int? {
        
        
        guard let catalogs = currentBook?.catalogs else {
            
            return nil
        }
        
        
        guard   let catalog = catalogs.first(where: { (item) -> Bool in
            
            item.chapterUrl == currentCatalog?.chapterUrl
            
        }) else {
            
            return nil
            
        }
        
        
        guard  let currentIndex = catalogs.index(of: catalog) else {
            
            return nil
            
        }

        return currentIndex
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
        
        if paragraphes.count  == 0 {
            
            return paragraphes
        }
        
        var pages:[String] = [String]()
        
        let height = UIScreen.main.bounds.height - 30 - 30
        
        let width = UIScreen.main.bounds.width -  15 - 6
        
        var tempPageContent :String = ""
        
        for j in 0..<paragraphes.count {
            
            let str = paragraphes[j]
            
            var tempStr = tempPageContent == "" ?   str  : tempPageContent +  "\r" + str
            
            let  size =  tempStr.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: getTextContetAttributes(), context: nil)
            
            
            if  size.height < height {
                
                tempPageContent =   tempStr
                
            } else {
                
                tempPageContent += "\r"
                
                for (_,char) in str.characters.enumerated() {
                    
                    let ch = String(char)
                    
                    tempStr = tempPageContent + ch
                    
                    let   tempSize =  tempStr.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: getTextContetAttributes(), context: nil)
                    
                    
                    if  tempSize.height > height {
                        
                        pages.append(tempPageContent)
                        
                        //                        let temp =  tempPageContent.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: getTextContetAttributes(), context: nil)
                        
                        // print("将要添加到页面的文本大小:\(temp)")
                        
                        tempPageContent = ch
                        
                    } else {
                        
                        tempPageContent += ch
                    }
                    
                }
                
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
