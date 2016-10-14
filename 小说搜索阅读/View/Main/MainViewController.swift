//
//  MainViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupChildControllers()
        
        
        
    }
    
    
    
}


extension MainViewController {
    
    
    func setupChildControllers()
    {
        // 判断是否登录，如果登录那么就有个人书架，如果没有登录就不添加个人书架选项
        
        var  array = [
            
            ["clsName": "RankViewController", "title": "排行榜", "imageName" : "home"],
            ["clsName": "RecommendViewController", "title": "推荐", "imageName" : "message_center"],
            ["clsName": "HotViewController", "title": "热门", "imageName" : "hot"],
            
            ]
        
       // var isLoaded:Bool = true
        
        
        if true {
            
            array.insert( ["clsName": "RankViewController", "title": "个人书架", "imageName" : "profile"], at: 0)
            
        }
        
        
        
        
        
        var arrayM = [UIViewController]()
        
        
        for dict in array {
            
            arrayM.append(createController(dic: dict))
            
        }
        
        viewControllers = arrayM
        
    }
    
    
    func createController(dic:[String:String]) ->UIViewController {
        
        guard  let clsName = dic["clsName"],
            let title = dic["title"],
            let imageName = dic["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
                
                return UIViewController()
        }
        
        
        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.title  = title
        
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")
        
        
        // vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
            for: UIControlState(rawValue: 0))
        
        let nav = NavigationViewController(rootViewController: vc)
        
        return nav
        
    }
    
}
