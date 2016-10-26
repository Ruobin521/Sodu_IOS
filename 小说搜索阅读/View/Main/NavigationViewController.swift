//
//  NavigationViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationBar.isHidden = true
        
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //  如果不是栈底才需要隐藏
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            var title  =  "返回"
            
            if childViewControllers.count == 1 {
                // 判断控制器的类型
                
                title =  childViewControllers.first?.title ?? "返回"
                
            }
            
            if let vc = viewController  as?  BaseViewController {
                
                vc.navItem.leftBarButtonItem =  UIBarButtonItem(title: title, fontSize:15.0,  target: self, action: #selector(goBack),isBack:true)
                
            }
            
        }
        
        super.pushViewController(viewController, animated:  animated)
        
    }
    
    func goBack()  {
        
        popViewController(animated: true)
    }
    
    
}
