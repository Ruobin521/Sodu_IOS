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
    
    
    let lineSpaces:[Float] = [5.0,10.0,15.0]
    
    
    
    var contentAndTextColorIndex:Int {
        
        get {
            
            return    ViewModelInstance.instance.setting.contentAndTextColorIndex
        }
        
        set {
            
            if ViewModelInstance.instance.setting.contentAndTextColorIndex != newValue {
                
                ViewModelInstance.instance.setting.contentAndTextColorIndex = newValue
            }
            
        }
        
    }
    
    
    var  daylightBackColor:UIColor! {
        
        get{
            
            let dic = ContentColorInfo[contentAndTextColorIndex]
            
            return  UIColor.colorWithHexString(hex: dic["backColor"]!)
            
        }
        
    }
    
    
    var  daylightForegroundColor:UIColor! {
        
        get{
            
            let dic = ContentColorInfo[contentAndTextColorIndex]
            
            return UIColor.colorWithHexString(hex: dic["textColor"]!)
        }
    }
    
    
    
    var fontSize:Float {
        
        get {
            
            return ViewModelInstance.instance.setting.contentTextSize
            
        }
        set {
            
            ViewModelInstance.instance.setting.contentTextSize = newValue
        }
        
        
    }
    
    
    
    var lineSpace:Float  {
        
        get {
            
            return ViewModelInstance.instance.setting.contentLineSpace
            
        }
        set {
            
            ViewModelInstance.instance.setting.contentLineSpace = newValue
            
        }
        
    }
    
    var lightValue:Float  {
        
        get {
            
            return ViewModelInstance.instance.setting.contentLightValue
            
        }
        set {
            
            ViewModelInstance.instance.setting.contentLightValue =  newValue
            
        }
        
    }
    
    
    
    var isMoomlightMode:Bool {
        
        get {
            
            return ViewModelInstance.instance.setting.isMoomlightMode
            
        }
        set {
            
            ViewModelInstance.instance.setting.isMoomlightMode = newValue
            
        }
        
    }
    
    //滚动方向 默认横向 H   纵向 V
    var orientation : UIPageViewControllerNavigationOrientation  {
        
        get  {
            
            return  ViewModelInstance.instance.setting.contentOrientation
        }
        set {
            
            ViewModelInstance.instance.setting.contentOrientation = newValue
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
            
            let catalog = BookCatalog(currentBook?.bookId, currentBook?.lastReadChapterName, currentBook?.LastReadContentPageUrl, nil)
            
            SetCurrentCatalog(catalog: catalog, completion: nil)
            
        }
    }
    
    var contentDic:[String:[String]] = [String:[String]]()
    
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
    
    
    init() {
        
        let index = ViewModelInstance.instance.setting.contentAndTextColorIndex
        
        
        contentAndTextColorIndex = index
        
        
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
            
            currentBook?.lastReadChapterName = _currentCatalog?.chapterName
            
            currentBook?.LastReadContentPageUrl = _currentCatalog?.chapterUrl
            
            if currentBook?.isLocal == "0" {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddHistoryNotification), object: currentBook)
                
            } else {
                
                if let  tempBook =  ViewModelInstance.instance.localBook.bookList.first(where: { (item) -> Bool in
                    
                    item.book.bookId == currentBook?.bookId
                    
                })?.book  {
                    
                    tempBook.lastReadChapterName = _currentCatalog?.chapterName
                    
                    tempBook.LastReadContentPageUrl = _currentCatalog?.chapterUrl
                    
                    ViewModelInstance.instance.localBook.updateBookDB(book: tempBook, completion: nil)
                }
                
            }
            
            preLoadCatalogContent()
        }
    }
    
    
    
    func preLoadCatalogContent() {
        
        
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
    
    
    
    
    //MARK: 获取目录列表
    func getBookCatalogs(url:String,retryCount:Int,completion: ((_ isSuccess:Bool)->())?)  {
        
        
        self.isRequestCatalogs = true
        
        guard  let bookid = self.currentBook?.bookId else {
            
            completion?(false)
            
            self.isRequestCatalogs = false
            
            return
            
        }
        
        if self.currentBook?.isLocal == "1" {
            
            DispatchQueue.global().async {
                
                let catalogs = SoDuSQLiteManager.shared.selectBookCatalogs(bookId: bookid)
                
                if catalogs.count > 0 {
                    
                    self.currentBook?.catalogs = catalogs
                    
                    if  let  catalog = self.getCatalogByPosion(posion: .Current) {
                        
                        self._currentCatalog = catalog
                        
                        self.preLoadCatalogContent()
                        
                    }
                    
                    completion?(true)
                    
                } else {
                    
                    completion?(false)
                }
                
                self.isRequestCatalogs = false
                
                
            }
            
        }
            
        else {
            
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
                        
                        self?._currentCatalog = catalog
                        
                        self?.preLoadCatalogContent()
                        
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
        
        
    }
    
    //MARK: 获取相应章节内容
    func getCatalogChapterContent(catalog:BookCatalog?,_ completion: ((_ isSuccess:Bool,_ strs:String?)->())?) -> URLSessionDataTask?  {
        
        print("开始加载章节：\((catalog?.chapterName)!)")
        
        let task =  CommonPageViewModel.getCatalogContent(catalog: catalog!,bookName: (self.currentBook?.bookName)!) { (isSuccess, html) in
            
            if isSuccess {
                
                print("章节：\((catalog?.chapterName)!) 加载成功")
                
            } else {
                
                print("章节：\(catalog?.chapterName) 加载失败")
            }
            
            completion?(isSuccess,html)
        }
        
        return task
    }
    
    
    
    //MARK: 根据枚举值获取章节 catalog
    func getCatalogByPosion(posion:CatalogPosion) -> BookCatalog? {
        
        guard let catalogs = currentBook?.catalogs ,let catalog = currentCatalog else {
            
            if posion == .Current {
                
                return currentCatalog
                
            } else {
                
                return nil
            }
            
            
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
        
        var task:URLSessionDataTask?
        
        
        guard let catalog = getCatalogByPosion(posion: posion) else{
            
            completion?(false)
            return
        }
        
        
        if contentDic[catalog.chapterUrl!] != nil {
            
            completion?(true)
            
            return
            
        }  else  if catalog.chapterContent != nil {
            
            DispatchQueue.global().async {
                
                guard let  pages = self.splitPages(html: catalog.chapterContent) else {
                    
                    completion?(false)
                    
                    return
                }
                
                self.contentDic[catalog.chapterUrl!] = pages
                
                if posion == .Current {
                    
                    self.currentChapterPageList = pages
                }
                
                completion?(true)
                
            }
            
        } else {
            
            
            task = self.getCatalogChapterContent(catalog: catalog) { (isSuccess,html) in
                
                if isSuccess {
                    
                    catalog.chapterContent = html
                    
                    DispatchQueue.global().async {
                        
                        guard let  pages = self.splitPages(html: catalog.chapterContent) else {
                            
                            completion?(false)
                            
                            return
                        }
                        
                        self.contentDic[catalog.chapterUrl!] = pages
                        
                        if posion == .Current {
                            
                            self.currentChapterPageList = pages
                        }
                        
                        completion?(true)
                        
                    }
                    
                } else {
                    
                    count += 1
                    
                    if count  <= self.retryNumber {
                        
                        if posion == .Before &&  self.isPreCanclled {
                            
                            completion?(false)
                            
                            return
                            
                        }
                        else  if posion == .Current &&  self.isCurrentCanclled {
                            
                            completion?(false)
                            return
                        }
                            
                        else if posion == .Next &&  self.isNextCanclled {
                            
                            completion?(false)
                            return
                        }
                        
                        self.getCatalogContentByPosin(posion: posion,retryCount:count, completion: completion)
                        
                        
                    } else {
                        
                        self.isPreCanclled = false
                        
                        completion?(false)
                        
                    }
                    
                }
            }
            
            if posion == .Before {
                
                preTask = task
                
            } else if posion == .Current {
                
                currentTask = task
                
            } else if posion == .Next {
                
                nextTask = task
                
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
        
        return catalogs.index(of: tempCatalog)
        
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
    
    
    
    func splitPages(html:String?) -> [String]?{
        
        var pages:[String] = [String]()
        
        
        guard  let str = html else {
            
            return nil
        }
        
        let paragraphes = str.components(separatedBy: "\n")
        
        if paragraphes.count  == 0 {
            
            return nil
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
            
            return nil
            
        } else {
            
            return pages
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
