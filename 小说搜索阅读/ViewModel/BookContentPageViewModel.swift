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
    
    
    var  daylightBackColor:UIColor = UIColor.colorWithHexString(hex: ViewModelInstance.instance.setting.contentBackColor) {
        
        didSet {
            
            //  ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentBackColor, daylightBackColor.cgColor)
            
        }
        
    }
    
    
    var  daylightForegroundColor:UIColor =  UIColor.colorWithHexString(hex: ViewModelInstance.instance.setting.contentTextColor) {
        
        didSet {
            
            // ViewModelInstance.Instance.Setting.setValue(SettingKey.ContentTextSize, fontSize)
            
        }
        
    }
    
    
    
    var fontSize:Float = ViewModelInstance.instance.setting.contentTextSize   {
        
        didSet {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentTextSize, fontSize)
            
        }
        
    }
    
    
    
    var lineSpace:Float = ViewModelInstance.instance.setting.contentLineSpace  {
        
        didSet {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentLineSpace, lineSpace)
            
        }
        
    }
    
    
    
    var isMoomlightMode =  ViewModelInstance.instance.setting.isMoomlightMode {
        
        didSet {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.IsMoomlightMode, isMoomlightMode)
            
        }
        
    }
    
    //滚动方向 默认横向
    var orientation : UIPageViewControllerNavigationOrientation  = .horizontal
    
    // h  / v
    var direction =  ViewModelInstance.instance.setting.contentOrientation ??  "h"   {
        
        didSet {
            
            if direction == "h" {
                
                orientation = UIPageViewControllerNavigationOrientation.horizontal
                
            } else  if direction == "v" {
                
                orientation = UIPageViewControllerNavigationOrientation.vertical
            }
            
        }
        
    }
    
    
    //数据部分
    
    
    
    var isRequestContent = false
    var isRequestCatalogs = false
    
    var currentBook:Book?  {
        
        didSet {
            
            let  catalog = BookCatalog(currentBook?.bookId, currentBook?.chapterName, currentBook?.contentPageUrl, nil)
            
            SetCurrentCatalog(catalog: catalog, completion: nil)
            
        }
    }
    
    
    var preChapterPageList:[String]?
    
    var currentChapterPageList:[String]?
    
    var nextChapterPageList:[String]?
    
    
    var preCatalog:BookCatalog?
    
    var nextCatalog:BookCatalog?
    
    private var _currentCatalog:BookCatalog?
    
    var currentCatalog:BookCatalog? {
        
        get {
            
            return _currentCatalog
            
        }
        
    }
    
    
    /// MARK: 设置当前章节，这是设置当前章节的唯一入口
    func SetCurrentCatalog(catalog:BookCatalog?,completion:(()->())?) {
        
        
        if catalog == nil {
            
            completion?()
            
            return
        }
        
        
        if catalog?.chapterUrl == currentCatalog?.chapterUrl {
            
            return
            
        }
        
        if currentBook?.catalogs != nil && (currentBook?.catalogs?.count)! > 0 {
            
            guard   let index = getCatalogIndex(catalog!) else {
                
                completion?()
                return
            }
            
            _currentCatalog =  currentBook?.catalogs?[index]
            
        }
        else {
            
            _currentCatalog = catalog
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddHistoryNotification), object: currentBook)
        
        // 滑到了下一章
        if nextCatalog?.chapterUrl == currentCatalog?.chapterUrl {
            
            currentChapterPageList = nextChapterPageList
            
        }
            
            //滑到了上一章
        else if preCatalog?.chapterUrl == currentCatalog?.chapterUrl {
            
            currentChapterPageList = preChapterPageList
            
        } else {
            
            currentChapterPageList = nil
            
            preChapterPageList = nil
            
            nextChapterPageList = nil
            
        }
        
        
        
        
        if currentChapterPageList == nil  {
            
            if currentCatalog?.chapterContent == nil {
                
                //                getCatalogChapterContent(catalog: currentCatalog) { [weak self]  (isSuccess,html) in
                //
                //                    if isSuccess {
                //
                //                        self?.currentChapterPageList = self?.splitPages(html: html)
                //
                //                    }
                //                }
                
            } else {
                
                self.currentChapterPageList = self.splitPages(html: currentCatalog?.chapterContent)
                
            }
            
        }
        
        
        DispatchQueue.global().async {
            
            if self.currentBook?.catalogs != nil && (self.currentBook?.catalogs?.count)! > 0 {
                
                self.setBeforeAndNextCatalog()
                
                if self.nextCatalog != nil && self.nextCatalog?.chapterContent == nil  {
                    
                    self.getCatalogChapterContent(catalog: self.nextCatalog) { [weak self]  (isSuccess,html) in
                        
                        if isSuccess {
                            
                            self?.nextChapterPageList = self?.splitPages(html: html)
                            
                        }
                    }
                    
                }
                    
                else {
                    
                    self.nextChapterPageList = self.splitPages(html: self.nextCatalog?.chapterContent)
                    
                }
                
                
                if self.preCatalog != nil && self.preCatalog?.chapterContent == nil {
                    
                    self.getCatalogChapterContent(catalog: self.preCatalog) { [weak self]  (isSuccess,html) in
                        
                        if isSuccess {
                            
                            self?.preChapterPageList = self?.splitPages(html: html)
                            
                        }
                    }
                    
                    
                }
                    
                else {
                    
                    self.preChapterPageList = self.splitPages(html: self.preCatalog?.chapterContent)
                    
                }
                
            }
        }
        
        
        
        
    }
    
    
    
    // MARK:  设置前后 章节
    func  setBeforeAndNextCatalog() {
        
        if currentBook?.catalogs != nil && (currentBook?.catalogs?.count)! > 0 {
            
            preCatalog = getCatalogByPosion(posion: .Before)
            
            nextCatalog = getCatalogByPosion(posion: .Next)
        }
        
    }
    
    //MARK: 获取相应目录内容
    func getCatalogChapterContent(catalog:BookCatalog?,_ completion: ((_ isSuccess:Bool,_ strs:String?)->())?)  {
        
        
        guard let url = catalog?.chapterUrl else{
            
            completion?(false,nil)
            
            return
        }
        
        print("开始加载章节：\((catalog?.chapterName)!)")
        
        getContentByUrl(url) { (isSuccess, html) in
            
            if isSuccess {
                
                catalog?.chapterContent = html
                print("章节：\((catalog?.chapterName)!) 加载成功")
                
            } else {
                
                print("章节：\(catalog?.chapterName) 加载失败")
            }
            
            completion?(isSuccess,html)
        }
    }
    
    
    ///MARK:  获取正文内容
    func getContentByUrl(_ url:String,_ retryCount:Int = 0,_ completion:@escaping (_ isSuccess:Bool,_ html:String?)->())  {
        
        self.isRequestContent = true
        
        var count = retryCount
        
        DispatchQueue.global().async {
            
            CommonPageViewModel.getHtmlByURL(url: url) {[weak self] (isSuccess, html) in
                
                if isSuccess {
                    
                    if  let  htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.Content) as? String {
                        
                        count = 0
                        
                        self?.isRequestContent = false
                        
                        completion(true,htmlValue)
                        
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
                        
                        print("获取\(url)正文失败，正在进行第\(count)次尝试")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    /// MARK: 获取目录列表
    func getBookCatalogs(url:String,retryCount:Int,completion: ((_ isSuccess:Bool)->())?)  {
        
        
        self.isRequestCatalogs = true
        
        guard  let bookid = self.currentBook?.bookId else {
            
            completion?(false)
            
            self.isRequestCatalogs = false
            
            return
            
        }
        
        CommonPageViewModel.getBookCIAC(url: url, bookid: bookid) { [weak self] (isSuccess, value:Any?) in
            
            var count = retryCount
            
            if isSuccess {
                
                let result = value as? (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)
                
                self?.currentBook?.catalogs = result?.catalogs
                
                self?.currentBook?.introduction = result?.introduction
                
                self?.currentBook?.coverImage = result?.cover
                
                self?.currentBook?.author = result?.author
                
                self?.isRequestCatalogs = false
                
                
                
                let  catalog = self?.getCatalogByPosion(posion: .Current)
                
                catalog?.chapterContent = self?.currentCatalog?.chapterContent
                
                self?.nextCatalog = self?.getCatalogByPosion(posion: .Next)
                
                self?.preCatalog = self?.getCatalogByPosion(posion: .Before)
                
                
                DispatchQueue.global().async {
                    
                    self?.getCatalogChapterContent(catalog: self?.nextCatalog) { (isSuccess,html) in
                        
                        if isSuccess {
                            
                            
                            
                            self?.nextChapterPageList  = self?.splitPages(html: html)
                        }
                        
                        
                    }
                    
                    
                    self?.getCatalogChapterContent(catalog: self?.preCatalog) { (isSuccess,html) in
                        
                        if isSuccess {
                            
                            self?.preChapterPageList  = self?.splitPages(html: html)
                        }
                        
                        
                    }
                }
                
                print("获取\(self?.currentBook?.bookName ?? " ")目录成功")
                
                
                
            } else {
                
                count += 1
                
                self?.isRequestCatalogs = false
                
                if count  == 4 {
                    
                    completion?(false)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，不再尝试，操蛋")
                    
                } else {
                    
                    self?.getBookCatalogs(url: url,retryCount:count, completion: completion)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，正在进行第\(count)次尝试")
                    
                }
            }
        }
        
    }
    
    
    //MARK: 根据枚举值获取上一个章节 和下一章节信息
    func getCatalogByPosion(posion:CatalogPosion) -> BookCatalog? {
        
        guard let catalogs = currentBook?.catalogs ,let catalog = currentCatalog else {
            
            return nil
        }
        
        
        guard  let currentIndex = getCatalogIndex(catalog)  else {
            
            return nil
            
        }
        
        
        var requestIndex = 0
        
        if posion == .Before {
            
            requestIndex = currentIndex - 1
            
        } else if  posion == .Next {
            
            requestIndex = currentIndex + 1
            
        } else if posion == .Current {
            
            
            requestIndex = currentIndex
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
        
        
        guard   let tempCatalog = catalogs.first(where: { (item) -> Bool in
            
            item.chapterUrl == catalog.chapterUrl
            
        }) else {
            
            return nil
            
        }
        
        
        guard  let currentIndex = catalogs.index(of: tempCatalog) else {
            
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
    
    
    
    func splitPages(html:String?)  -> [String]? {
        
        guard  let str = html else {
            
            return nil
        }
        
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
