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
    
    
    var  daylightBackColor:UIColor  {
        
        
        get {
            
            return UIColor.colorWithHexString(hex: ViewModelInstance.instance.setting.contentBackColor)
            
        }
        
        set{
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentBackColor, newValue)
            
        }
        
    }
    
    
    var  daylightForegroundColor:UIColor  {
        
        
        get {
            
            return  UIColor.colorWithHexString(hex: ViewModelInstance.instance.setting.contentTextColor)
        }
        
        set{
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentTextColor, newValue)
            
        }
        
    }
    
    
    
    var fontSize:Float {
        
        get {
            
            return ViewModelInstance.instance.setting.contentTextSize
            
        }
        set {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentTextSize, newValue)
        }
        
        
    }
    
    
    
    var lineSpace:Float  {
        
        get {
            
            return ViewModelInstance.instance.setting.contentLineSpace
            
        }
        set {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.ContentLineSpace, newValue)
            
        }
        
    }
    
    
    
    var isMoomlightMode:Bool {
        
        get {
            
            return ViewModelInstance.instance.setting.isMoomlightMode
            
        }
        set {
            
            ViewModelInstance.instance.setting.setValue(SettingKey.IsMoomlightMode, newValue)
            
        }
        
        
        
    }
    
    //滚动方向 默认横向 H   纵向 V
    var orientation : UIPageViewControllerNavigationOrientation  {
        
        get  {
            
            let ori =   ViewModelInstance.instance.setting.contentOrientation
            
            if ori == "H" {
                
                return  UIPageViewControllerNavigationOrientation.horizontal
                
            } else {
                
                return  UIPageViewControllerNavigationOrientation.vertical
            }
            
        }
        set {
            
            if newValue == UIPageViewControllerNavigationOrientation.horizontal {
                
                return    ViewModelInstance.instance.setting.setValue(SettingKey.IsMoomlightMode, "H")
                
                
            } else {
                
                return    ViewModelInstance.instance.setting.setValue(SettingKey.IsMoomlightMode, "V")
                
            }
        }
        
    }
    
    
    
    
    //数据部分
    
    
    var currentTask : URLSessionDataTask?
    
    var preTask : URLSessionDataTask?
    
    var nextTask : URLSessionDataTask?
    
    var catalogTask : URLSessionDataTask?
    
    let retryNumber = 3
    
    var isCurrentCanclled = false
    
    var isPreCanclled = false
    
    var isNextCanclled = false
    
    var isCatalogCanclled = false
    
    var isRequestContent = false
    
    var isRequestCatalogs = false
    
    
    var currentBook:Book?  {
        
        didSet {
            
            let catalog = BookCatalog(currentBook?.bookId, currentBook?.chapterName, currentBook?.contentPageUrl, nil)
            
            SetCurrentCatalog(catalog: catalog, completion: nil)
            
        }
    }
    
    var contentDic = [String:[String]]()
    
    
    var currentChapterPageList:[String]?
    
    var preChapterPageList:[String]?
    
    var nextChapterPageList:[String]?
    
    var preCatalog:BookCatalog?
    
    var nextCatalog:BookCatalog?
    
    
    
    private var _currentCatalog:BookCatalog?
    
    var currentCatalog:BookCatalog? {
        
        get {
            
            return _currentCatalog
            
        }
        
    }
    
    
    //MARK: 设置当前章节，这是设置当前章节的唯一入口
    func SetCurrentCatalog(catalog:BookCatalog?,completion:(()->())?) {
        
        
        if catalog == nil  || catalog?.chapterUrl == nil {
            
            completion?()
            
            return
        }
        
        
        if currentCatalog?.chapterUrl == catalog?.chapterUrl {
            
            return
        }
        
        if currentCatalog?.chapterUrl != catalog?.chapterUrl {
            
            _currentCatalog =  catalog
            
            currentBook?.chapterName = _currentCatalog?.chapterName
            
            currentBook?.contentPageUrl = _currentCatalog?.chapterUrl
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddHistoryNotification), object: currentBook)
            
            
        }
        
        
        guard let _ = currentBook?.catalogs else {
            
            return
        }
        
        
        self.setBeforeAndNextCatalog()
        
        if preCatalog != nil {
            
            getCatalogContentByPosin(posion: .Before, completion: { (isSuccess) in
                
                if isSuccess {
                    
                    self.preChapterPageList = self.contentDic[(self.preCatalog?.chapterUrl)!]
                }
                
            })
            
        }
        
        
        if nextCatalog != nil {
            
            getCatalogContentByPosin(posion: .Next, completion: { (isSuccess) in
                
                if isSuccess {
                    
                    self.nextChapterPageList = self.contentDic[(self.nextCatalog?.chapterUrl)!]
                }
                
            })
            
        }
        
    }
    
    
    
    //MARK:  设置前后 章节
    func  setBeforeAndNextCatalog() {
        
        if currentBook?.catalogs != nil && (currentBook?.catalogs?.count)! > 0 {
            
            preCatalog = getCatalogByPosion(posion: .Before)
            
            nextCatalog = getCatalogByPosion(posion: .Next)
        }
        
    }
    
    //MARK: 获取相应章节内容
    func getCatalogChapterContent(catalog:BookCatalog?,_ completion: ((_ isSuccess:Bool,_ strs:String?)->())?) -> URLSessionDataTask?  {
        
        guard let url = catalog?.chapterUrl else{
            
            completion?(false,nil)
            
            return nil
        }
        print("开始加载章节：\((catalog?.chapterName)!)")
        
        
        let task =  getContentByUrl(url) { (isSuccess, html) in
            
            if isSuccess {
                
                catalog?.chapterContent = html
                print("章节：\((catalog?.chapterName)!) 加载成功")
                
            } else {
                
                print("章节：\(catalog?.chapterName) 加载失败")
            }
            
            completion?(isSuccess,html)
        }
        
        return task
    }
    
    
    //MARK:  获取正文内容
    func getContentByUrl(_ url:String,_ completion:@escaping (_ isSuccess:Bool,_ html:String?)->()) -> URLSessionDataTask? {
        
        self.isRequestContent = true
        
        //var count = retryCount
        
        var task :  URLSessionDataTask?
        
        
        
        task =  CommonPageViewModel.getHtmlByURL(url: url) {[weak self] (isSuccess, html) in
            
            if self == nil {
                
                completion(false,nil)
            }
            
            if isSuccess {
                
                if  let  htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, html!,AnalisysType.Content) as? String {
                    
                    self?.isRequestContent = false
                    
                    completion(true,htmlValue)
                    
                } else {
                    
                    completion(false,nil)
                }
                
                
            }  else {
                
                completion(false,nil)
            }
            
        }
        
        return task
    }
    
    //MARK: 获取目录列表
    func getBookCatalogs(url:String,retryCount:Int,completion: ((_ isSuccess:Bool)->())?)  {
        
        
        self.isRequestCatalogs = true
        
        guard  let bookid = self.currentBook?.bookId else {
            
            completion?(false)
            
            self.isRequestCatalogs = false
            
            return
            
        }
        
        catalogTask = CommonPageViewModel.getBookCIAC(url: url, bookid: bookid) { [weak self] (isSuccess, value:Any?) in
            
            if self == nil {
                
                completion?(false)
            }
            
            var count = retryCount
            
            if isSuccess {
                
                let result = value as? (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)
                
                self?.currentBook?.catalogs = result?.catalogs
                
                self?.currentBook?.introduction = result?.introduction
                
                self?.currentBook?.coverImage = result?.cover
                
                self?.currentBook?.author = result?.author
                
                self?.isRequestCatalogs = false
                
                
                if  let  catalog = self?.getCatalogByPosion(posion: .Current) {
                    
                    catalog.chapterContent = self?.currentCatalog?.chapterContent
                    
                    self?.SetCurrentCatalog(catalog: catalog, completion: nil)
                    
                }
                
                
                print("获取\(self?.currentBook?.bookName ?? " ")目录成功")
                
                self?.catalogTask = nil
                
                return
                
            } else {
                
                count += 1
                
                self?.isRequestCatalogs = false
                
                if count <= (self?.retryNumber)! && !(self?.isCatalogCanclled)! {
                    
                    self?.getBookCatalogs(url: url,retryCount:count, completion: completion)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，正在进行第\(count)次尝试")
                    
                    
                } else {
                    
                    completion?(false)
                    print("获取\((self?.currentBook?.bookName) ?? " ")目录失败，不再尝试，操蛋")
                    
                }
            }
        }
        
    }
    
    
    //MARK: 根据枚举值获取章节 catalog
    func getCatalogByPosion(posion:CatalogPosion) -> BookCatalog? {
        
        guard let catalogs = currentBook?.catalogs ,let catalog = currentCatalog else {
            
            
            return nil
        }
        
        guard  let currentIndex = getCatalogIndex((catalog.chapterUrl)!)  else {
            
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
        
        
        if requestIndex >= 0 && requestIndex < catalogs.count  {
            
            return catalogs[requestIndex]
            
        }
        
        return nil
        
    }
    
    
    
    
    //MARK: 根据枚举值获章节内容 content
    func getCatalogContentByPosin(posion:CatalogPosion,retryCount:Int = 0,completion: ((_ isSuccess:Bool)->())?) {
        
        var count = retryCount
        
        ///上一章节
        if posion == CatalogPosion.Before {
            
            guard let catalog = self.preCatalog else {
                
                return
            }
            
            if  let _ = contentDic[catalog.chapterUrl!] {
                
                completion?(true)
            }
                
            else  if catalog.chapterContent != nil {
                
                self.preTask?.cancel()
                
                self.preTask = nil
                
                self.splitPages(html: catalog.chapterContent, completion: { (pages) in
                    
                    self.contentDic[catalog.chapterUrl!] = pages
                    
                    completion?(true)
                    
                })
                
            } else {
                
                preTask = self.getCatalogChapterContent(catalog: catalog) { (isSuccess,html) in
                    
                    self.preTask = nil
                    
                    if isSuccess {
                        
                        self.splitPages(html: html, completion: { (pages) in
                            
                            
                            self.contentDic[catalog.chapterUrl!] = pages
                            
                            completion?(true)
                            
                        })
                        
                    } else {
                        
                        count += 1
                        
                        if count  <= self.retryNumber && !self.isPreCanclled {
                            
                            self.getCatalogContentByPosin(posion: posion,retryCount:count, completion: completion)
                            
                            
                        } else {
                            
                            
                            self.isPreCanclled = false
                            completion?(false)
                            
                        }
                        
                    }
                }
                
            }
        }
            
            /// 下一章节
        else if posion == CatalogPosion.Next {
            
            guard let catalog = self.nextCatalog else {
                
                return
            }
            
            if  let _ = contentDic[catalog.chapterUrl!] {
                
                completion?(true)
            }
                
            else  if catalog.chapterContent != nil {
                
                self.nextTask?.cancel()
                
                self.nextTask = nil
                
                self.splitPages(html: catalog.chapterContent, completion: { (pages) in
                    
                    self.contentDic[catalog.chapterUrl!] = pages
                    
                    completion?(true)
                    
                })
                
            } else {
                
                nextTask = self.getCatalogChapterContent(catalog: catalog) { (isSuccess,html) in
                    
                    self.nextTask = nil
                    
                    if isSuccess {
                        
                        self.splitPages(html: html, completion: { (pages) in
                            
                            
                            self.contentDic[catalog.chapterUrl!] = pages
                            
                            completion?(true)
                            
                        })
                        
                    } else {
                        
                        count += 1
                        
                        if count  <= self.retryNumber && !self.isNextCanclled {
                            
                            self.getCatalogContentByPosin(posion: posion,retryCount:count, completion: completion)
                            
                            
                        } else {
                            
                            self.isNextCanclled = false
                            completion?(false)
                            
                        }
                    }
                    
                }
                
            }
            
        }
            
            
            /// 当前章节
        else if posion == CatalogPosion.Current {
            
            guard let catalog = self.currentCatalog else {
                
                return
            }
            
            if  let _ = contentDic[catalog.chapterUrl!] {
                
                completion?(true)
            }
                
            else  if catalog.chapterContent != nil {
                
                self.splitPages(html: catalog.chapterContent, completion: { (pages) in
                    
                    self.currentChapterPageList  = pages
                    
                    self.contentDic[catalog.chapterUrl!] = pages
                    
                    completion?(true)
                    
                })
                
                
            } else {
                
                currentTask = self.getCatalogChapterContent(catalog: catalog) { (isSuccess,html) in
                    
                    self.currentTask = nil
                    
                    if isSuccess {
                        
                        self.splitPages(html: html, completion: { (pages) in
                            
                            self.currentChapterPageList  = pages
                            
                            self.contentDic[catalog.chapterUrl!] = pages
                            
                            completion?(true)
                            
                        })
                        
                    } else {
                        
                        count += 1
                        
                        if count  <= self.retryNumber && !self.isCurrentCanclled {
                            
                            self.getCatalogContentByPosin(posion: posion,retryCount:count, completion: completion)
                            
                            
                        } else {
                            
                            self.isCurrentCanclled = false
                            completion?(false)
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func getCatalogIndex(_ url:String) ->Int? {
        
        
        guard let catalogs = currentBook?.catalogs else {
            
            return nil
        }
        
        var tempList = [BookCatalog]()
        
        for item in catalogs {
            
            if item.chapterUrl == url {
                
                tempList.append(item)
            }
            
        }
        
        guard   let tempCatalog =  tempList.last else {
            
            return nil
            
        }
        
        return tempCatalog.chapterIndex
        
    }
    
    
    
    func appendContentToDictionary(dic: (key: String, value: [String]) ) {
        
        if !contentDic.contains(where: { (temp: (key: String, value: [String])) -> Bool in
            
            temp.key ==  dic.key
            
        }) {
            
            self.contentDic[dic.key]  = dic.value
            
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
    
    
    
    func splitPages(html:String?,completion:@escaping ([String]?)->()){
        
        var pages:[String] = [String]()
        
        DispatchQueue.global().async {
            
            guard  let str = html else {
                
                return
            }
            
            let paragraphes = str.components(separatedBy: "\n")
            
            if paragraphes.count  == 0 {
                
                return
            }
            
            
            let height = UIScreen.main.bounds.height - 30 - 30
            
            let width = UIScreen.main.bounds.width -  15 - 6
            
            var tempPageContent :String = ""
            
            for j in 0..<paragraphes.count {
                
                let str = paragraphes[j]
                
                var tempStr = tempPageContent == "" ?   str  : tempPageContent +  "\r" + str
                
                let  size =  tempStr.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: self.getTextContetAttributes(), context: nil)
                
                
                if  size.height < height {
                    
                    tempPageContent =   tempStr
                    
                } else {
                    
                    tempPageContent += "\r"
                    
                    for (_,char) in str.characters.enumerated() {
                        
                        let ch = String(char)
                        
                        tempStr = tempPageContent + ch
                        
                        let   tempSize =  tempStr.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: self.getTextContetAttributes(), context: nil)
                        
                        
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
            
            if pages.count == 0 {
                
                completion(nil)
                
            } else {
                
                completion(pages)
            }
            
        }
        
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
    
}
