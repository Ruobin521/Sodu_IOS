//
//  CommonPageViewModel.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import  UIKit


/// 一些共同调用的方法
class CommonPageViewModel {
    
    ///导航到更新章节列表页
    static  func navigateToUpdateChapterPage(_ naviBook:Book?, _ navigationController : UINavigationController?)  {
        
        guard let book  = naviBook else {
            
            return
        }
        
        let vc = UpdateChapterViewController()
        
        let temp = book.clone()
        
        vc.vm.currentBook = temp
        
        let title = vc.vm.currentBook?.bookName
        
        if title != nil {
            
            vc.title =  vc.vm.currentBook?.bookName!
        }
        
        //print(vc.vm.currentBook)
        
        if ViewModelInstance.instance.setting.isAutoAddToShelf {
            
            AddBookToShelf(book: book.clone(),false)
        }
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /// 添加小说到个人书架
    ///
    /// - parameter book: 需要添加的小说
    static func AddBookToShelf(book:Book,_ notice:Bool = true) {
        
        let item = ViewModelInstance.instance.bookShelf.bookList.first(where: { (b) -> Bool in
            
            b.bookId == book.bookId
            
        })
        
        if item != nil {
            
            //  ToastView.instance.showGlobalToast(content: "\((book.bookName)!)已存个人书架")
            return
        }
        
        
        
        HttpUtil.instance.request(url: SoDuUrl.addTobookShelf + (book.bookId)!, requestMethod: .GET, postStr: nil,true) { (str, isSuccess) in
            
            DispatchQueue.main.async {
                
                if isSuccess && str != nil  && (str?.contains("{\"success\":true}"))!{
                    
                    
                    // ViewModelInstance.Instance.bookShelf.bookList.insert(book, at: 0)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddToBookshelfSuccessNotification), object: book)
                    
                    if notice {
                        
                        ToastView.instance.showGlobalToast(content: "已添加\((book.bookName)!)至个人书架")
                        
                    }
                    
                    
                }  else {
                    
                    if notice {
                        
                        ToastView.instance.showGlobalToast(content: "添加\((book.bookName)!)至个人书架失败")
                    }
                    
                }
                
            }
        }
    }
    
    
    ///html的请求方法
    static func   getHtmlByURL(url:String,completion:@escaping (_ isSuccess:Bool ,_ html:String?)->()) -> URLSessionDataTask? {
        
        let task =  HttpUtil.instance.AFrequest(url: url, requestMethod: .GET, postStr: nil, parameters: nil, timeOut: 10)   { (data,isSuccess) in
            
            if !isSuccess {
                
                completion(false,nil)
                
            }  else {
                
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                
                guard  let  str = String(data: data as! Data, encoding: String.Encoding(rawValue: enc)) else {
                    
                    completion(false,nil)
                    
                    return
                }
                
                completion(true,str)
            }
        }
        
        return task
    }
    
    
    //MARK: 获取章节正文内容
    static func   getCatalogContent(catalog:BookCatalog, bookName:String?,completion:@escaping (_ isSuccess:Bool ,_ html:String?)->()) -> URLSessionDataTask? {
        
        guard let url = catalog.chapterUrl else {
            
            return  nil
        }
        
        let task =  HttpUtil.instance.AFrequest(url: url, requestMethod: .GET, postStr: nil, parameters: nil, timeOut: 10)   { (data,isSuccess) in
            
            if !isSuccess {
                
                completion(false,nil)
                
            }  else {
                
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                
                guard  let  str = String(data: data as! Data, encoding: String.Encoding(rawValue: enc)) else {
                    
                    completion(false,nil)
                    
                    return
                }
                
                guard let htmlValue = AnalisysHtmlHelper.AnalisysHtml(url, str,AnalisysType.Content,bookName ?? "") as? String  else{
                    
                    completion(false,nil)
                    
                    return
                }
                
                catalog.chapterContent = htmlValue
                completion(true,htmlValue)
            }
        }
        
        return task
    }
    
    
    
    //MARK: 获取目录 封面 作者 简介
    static func   getBookCIAC(url:String,bookid:String,completion:@escaping (_ isSuccess:Bool , _ result: Any?) -> ()) -> URLSessionDataTask? {
        
        guard  let catalogPageUrl = AnalisysHtmlHelper.AnalisysHtml(url,"", AnalisysType.CatalogPageUrl) as? String else {
            
            completion(false,nil)
            return nil
        }
        
        
        let task =  CommonPageViewModel.getHtmlByURL(url: catalogPageUrl) { (isSuccess, html) in
            
            if isSuccess {
                
                guard let result = AnalisysHtmlHelper.AnalisysHtml(catalogPageUrl, html!,AnalisysType.CatalogList) as? (catalogs:[BookCatalog]?, introduction:String?,authorName:String?, cover:String?) else {
                    
                    completion(false,nil)
                    
                    return
                    
                }
                completion(true,result)
                
                
            } else {
                
                completion(false,nil)
                
            }
            
        }
        
        return task
    }
    
    
    static func getCatalogContent(urlString:String,bookName:String? = nil) -> String? {
        
        var result:String? = nil
        //创建NSURL对象
        let url:URL! = URL(string: urlString)
        //创建请求对象
        var urlRequest:URLRequest = URLRequest(url: url)
        //响应对象
        var response:URLResponse?
        
        urlRequest.timeoutInterval = 15
        
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        do {
            
            if  let data:Data =  try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: &response) as Data? {
                
                guard  let  str = String(data: data , encoding: String.Encoding(rawValue: enc)) else {
                    
                    return nil
                }
                
                guard let htmlValue = AnalisysHtmlHelper.AnalisysHtml(urlString, str,AnalisysType.Content,bookName ?? "") as? String  else{
                    
                    return nil
                }
                
                result = htmlValue
            }
            
        }catch {
            
            return nil
        }
        
        return result
    }
    
    
    
    
    

    /// 将中文转为utf8
    ///
    /// - Parameter str: <#str description#>
    /// - Returns: <#return value description#>
    static  func urlEncode(_ str:String) -> String {
        
        var st = str
        
        st =  str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        return st
        
    }
    
    
}
