//
//  PersonCenterViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/12.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class PersonCenterViewController: BaseViewController {
    
    @IBOutlet weak var txtUserName: UILabel!
    
    
    @IBAction func logout() {
        
        //发送logout通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogoutNotification), object: nil)
        
        _ =  navigationController?.popViewController(animated: true)
        
        
        ToastView.instance.showGlobalToast(content: "注销成功")
        
    }
    
}


extension  PersonCenterViewController {
    
    override func setupUI() {
        
        
        setUpNavigationBar()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        
        txtUserName.text =  ViewModelInstance.instance.userId
        
    }
}
