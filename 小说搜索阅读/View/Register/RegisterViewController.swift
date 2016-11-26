//
//  RegisterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPasswd: UITextField!
    
    
    @IBOutlet weak var txtConfirmPasswd: UITextField!
    
    
    let vm = UserLoginViewModel()
    
    
    @IBAction func registerAction() {
        
        if !checkInput() {
            
            return
        }
        
        if isLoading {
            
            self.showToast(content: "正在注册中，请稍后")
            return
        }
        
        isLoading = true
        
        vm.userRegister(txtUserName.text!, txtPasswd.text!, completion: { [weak self] (isSuccess) in
            
            
            if isSuccess {
                
                userLogon = true
                
                self?.showToast(content: "注册成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogonSuccessNotification), object: nil)
                
                self?.vm.setCoookie()
                
                
                
                self?.goBack()
                
            } else {
                
                self?.showToast(content: "注册失败，该用户可能已经注册过",false)
            }
            
            self?.isLoading = false
            
            
            
        })
        
    }
    
    
    func checkInput() -> Bool {
        
        if txtUserName.text == nil  || txtUserName.text?.trimmingCharacters(in: [" "])  == "" {
            
            ToastView.instance.showGlobalToast(content: "请输入用户名,且不能为空格",false)
            return false
        }
        
        if txtPasswd.text == nil  || txtPasswd.text?.trimmingCharacters(in: [" "])  == "" {
            
            ToastView.instance.showGlobalToast(content: "请输入密码,且不能为空格",false)
            return false
        }
        
        if txtConfirmPasswd.text == nil  || txtConfirmPasswd.text?.trimmingCharacters(in: [" "])  == "" {
            
            ToastView.instance.showGlobalToast(content: "请输入确认密码,且不能为空格",false)
            return false
        }
        
        if txtConfirmPasswd.text == nil  || txtConfirmPasswd.text?.trimmingCharacters(in: [" "])  == "" {
            
            ToastView.instance.showGlobalToast(content: "请输入确认密码,且不能为空格",false)
            return false
        }
        
        
        if  txtPasswd.text != txtConfirmPasswd.text {
            
            ToastView.instance.showGlobalToast(content: "两次密码输入不一致，请重新输入",false)
            return false
        }
        
        return true
    }
    
    
    @IBAction func goBack() {
        
        //  dismiss(animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
}

extension RegisterViewController {
    
    override func  setupUI()  {
        
        super.setUpNavigationBar()
        super.setBackColor()
        
        self.title = "注册"
        
        //  self.navItem.leftBarButtonItem? = UIBarButtonItem(title: "返回", fontSize:16.0,  target: self, action: #selector(goBack),isBack:true)
        
    }
    
    
}
