//
//  RegisterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPasswd: UITextField!
    
    
    @IBOutlet weak var txtConfirmPasswd: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerAction() {
        
        if !checkInput() {
            
            return
        }

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
    
    
    @IBAction func goBack(_ sender: Any) {
        
          dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
}
