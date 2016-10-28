//
//  CommonPageViewModel.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import  UIKit


/// 保存一些共同调用的方法
class CommonPageViewModel {
    
    ///导航到更新章节列表页
    static  func navigateToUpdateChapterPage(_ book:Book, _ navigationController : UINavigationController?)  {
        
        if (navigationController?.childViewControllers.count)! > 1 {
            
            return
        }
        
        let vc = UpdateChapterViewController()
        
        vc.vm.currentBook = book
        
        vc.title = book.bookName
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /// 添加小说到个人书架
    ///
    /// - parameter book: 需要添加的小说
    static func AddBookToShelf(book:Book) {
        
        let item = ViewModelInstance.Instance.bookShelf.bookList.first(where: { (b) -> Bool in
            
            b.bookId == book.bookId
            
        })
        
        if item != nil {
            
            ToastView.instance.showGlobalToast(content: "\((book.bookName)!)已存个人书架")
            return
        }
        
        
        
        HttpUtil.instance.request(url: SoDuUrl.addTobookShelf + (book.bookId)!, requestMethod: .GET, postStr: nil,true) { (str, isSuccess) in
            
            DispatchQueue.main.async {
                
                if isSuccess && str != nil  && (str?.contains("{\"success\":true}"))!{
                    
                    
                    // ViewModelInstance.Instance.bookShelf.bookList.insert(book, at: 0)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddToBookshelfSuccessNotification), object: book)
                    
                    ToastView.instance.showGlobalToast(content: "已添加\((book.bookName)!)至个人书架")
                    
                    
                }  else {
                    
                    ToastView.instance.showGlobalToast(content: "添加\((book.bookName)!)至个人书架失败")
                }
                
            }
        }
    }
    
    
}
