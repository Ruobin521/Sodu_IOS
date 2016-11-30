//
//  ContentPageViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/25.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class ContentPageViewController: UIViewController {
    
    
    var chapterName:String?
    
    var content:String?
    
    var battery:String?
    
    var time:String?
    
    var tag:Int = 0
    
    var pageIndex:String?
    
    var chapterIndex:String?
    
    var backColor:UIColor?
    
    
    var contPage:ContentPage?
    
    var textAttributeDic:[String:Any]?
    
    var test:String?
    
    var catalog:BookCatalog?
    
    
    
    
    override func loadView() {
        
        contPage = ContentPage.contentPage(chapterName,content,battery,time,textAttributeDic,chapterIndex,pageIndex)
        
        contPage?.backgroundColor = backColor ?? UIColor.clear
        
        self.view = contPage!
                
    }
    
    
    func setTextAttribute(_ attributes:[String:Any]?) {
        
        contPage?.setTextAttribute(attributes)
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
}
