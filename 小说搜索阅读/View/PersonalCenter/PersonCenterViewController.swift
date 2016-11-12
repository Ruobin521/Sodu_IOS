//
//  PersonCenterViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/12.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class PersonCenterViewController: UIViewController {
    
    @IBOutlet weak var txtUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUserName.text = UserDefaultsHelper.getUserDefaultByKey(key: .UserNameKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    @IBAction func logout() {
        
        userLogon = false
        
        UserLoginViewModel.deleteCoookie()
        
        //获取沙盒路径
        let docdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let jsonPath = (docdir as NSString).appendingPathComponent(ListType.BookShelf.rawValue + ".json")
        
        try?   FileManager.default.removeItem(atPath: jsonPath)
        
        UserDefaultsHelper.setUserDefaultsValueForKey(key: .UserNameKey, value: "")
        
        //发送logout通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogoutNotification), object: nil)
        
      _ =  navigationController?.popViewController(animated: true)
        
        
        ToastView.instance.showGlobalToast(content: "注销成功")
        
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        
        _ =  navigationController?.popViewController(animated: true)
        
    }
}
