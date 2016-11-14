//
//  DownCenterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let commonCellId = "cellId"
class DownCenterViewController: BaseViewController {
    
    
    
    
}


extension DownCenterViewController {
    
    
    override func setupUI() {
        
        self.navItem.title = "下载中心"
        setBackColor()
        setUpNavigationBar()
        setuoTableview()
        
        let cellNib1 = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableview?.register(cellNib1, forCellReuseIdentifier: commonCellId)
    }
    
    
}
