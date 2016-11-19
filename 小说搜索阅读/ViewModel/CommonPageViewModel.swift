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
    static  func navigateToUpdateChapterPage(_ book:Book, _ navigationController : UINavigationController?)  {
        
        
        let vc = UpdateChapterViewController()
        
        let temp = book.clone()
        
        vc.vm.currentBook = temp
        
        let title = vc.vm.currentBook?.bookName
        
        if title != nil {
            
            vc.title =  vc.vm.currentBook?.bookName!
        }
       
        //print(vc.vm.currentBook)
        
        if ViewModelInstance.Instance.Setting.isAutoAddToShelf {
            
            
            AddBookToShelf(book: book.clone(),false)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    /// 添加小说到个人书架
    ///
    /// - parameter book: 需要添加的小说
    static func AddBookToShelf(book:Book,_ notice:Bool = true) {
        
        let item = ViewModelInstance.Instance.bookShelf.bookList.first(where: { (b) -> Bool in
            
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
