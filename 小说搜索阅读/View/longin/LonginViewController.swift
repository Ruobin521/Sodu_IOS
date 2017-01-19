//
//  LonginViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class LonginViewController: BaseViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPasswd: UITextField!
    
    let vm = UserLoginViewModel()
    
  
    
    
    
    @IBAction func login(_ sender: Any) {
        
        if txtUserName.text == nil || txtUserName.text!.isEmpty  {
            
            ToastView.instance.showGlobalToast(content: "请输入用户名")
            return
        }
        
        if txtPasswd.text == nil || txtPasswd.text!.isEmpty {
            
            ToastView.instance.showGlobalToast(content: "请输入密码")
            return
        }
        
        
        login()
    }
    
    
    func login() {
        
        if isLoading {
            
            self.showToast(content: "正在登录，请稍后")
            return
        }
        
        isLoading = true
        
        vm.userLogin(txtUserName.text!, txtPasswd.text!, completion: { (isSuccess)  in
            
            
            if isSuccess {
                
                self.showToast(content: "登录成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogonSuccessNotification), object: nil)
                
                UserDefaultsHelper.setUserDefaultsValueForKey(key: .UserNameKey, value: (self.txtUserName.text)!)
                
                self.vm.setCoookie()
              
                self.goBack(nil)
                
            } else {
                
                self.showToast(content: "登录失败，请检查用户名密码",false)
            }
            
            self.isLoading = false
            
        })
        
    }
    
    @IBAction func registerAction() {
        
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    
    }
    
    @IBAction func goBack(_ sender: Any?) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

extension LonginViewController {
    
    override func  setupUI()  {
        
        setUpNavigationBar()
        setBackColor()
        
        self.title = "登录"
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize:16.0,  target: self, action: #selector(goBack),isBack:true)
    
//        #if DEBUG
//              
//        txtUserName.text = "918201"
//        txtPasswd.text = "8166450"
//        
//        #endif

    }
    
    
}

