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
    
    
    static  func navigateToUpdateChapterPage(_ book:Book, _ navigationController : UINavigationController?)  {
        
        let vc = UpdateChapterViewController()
        
        vc.vm.currentBook = book
        
        vc.navItem.title = book.bookName
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
