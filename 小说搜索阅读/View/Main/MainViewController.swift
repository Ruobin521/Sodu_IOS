//
//  MainViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit




class MainViewController: UITabBarController {
    
    
    var baseControllers:[BaseViewController]?
    
    var lastDate: NSDate?
    
    var selectedVC:BaseViewController?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        setupWelcomView()
        
        setupChildControllers()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: NeedLoginNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addBookShelfTabbar), name: NSNotification.Name(rawValue: LogonSuccessNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: LogoutNotification), object: nil)
        
        
        delegate = self
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    
    func addBookShelfTabbar() {
        
        let item =  ["clsName": "BookshelfViewController", "title": "个人书架", "imageName" : "profile"]
        
        DispatchQueue.main.async {
            
            self.showToast(content: "用户登陆成功")
            
            self.viewControllers?.insert(self.createController(dic: item), at: 0)
            
            self.selectedIndex =  (self.viewControllers?.count)! - 1  >= 0  ? (self.viewControllers?.count)! - 1  : 0
        }
        
    }
    
    
    func logout()  {
        
        self.viewControllers?.remove(at: 0)
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}


extension  MainViewController {
    
    func  setupWelcomView() {
        
        
        if !userLogon {
            
            return
        }
        
        
        let v = WelcomView.welcomView()
        
        v.frame = self.view.bounds
        
        self.view.addSubview(v)
        
    }
    
}

extension MainViewController {
    
    
    func login() {
        
        let vc =    NavigationViewController(rootViewController: LonginViewController())
        
        present(vc, animated: true, completion: nil)
    }
    
}




extension MainViewController:UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        guard  let tempvc = (viewController as? NavigationViewController)?.viewControllers[0] as? BaseViewController else {
            
            return false
        }
        
        if tempvc is SettingViewController {
            
            if !userLogon {
                
                login()
            }
        }
        
        return true
        
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        guard let nav = viewControllers?[selectedIndex]  as? UINavigationController else {
            
            return
        }
        
        guard  let tempvc = nav.viewControllers[0] as? BaseViewController else {
            
            return
        }
        
        if tempvc.isMember(of: SettingViewController.self) {
            
            return
            
        }
        
        let date = NSDate()
        
        
        if selectedVC == nil {
            
            lastDate = date
            
            selectedVC = tempvc
            
            return
        }
        
        let second = (date.timeIntervalSince(lastDate as! Date)) as Double
        
        if tempvc == selectedVC   &&  second  <= 0.5 {
            
            selectedVC?.goToTop()
            
            selectedVC = tempvc
            
            lastDate = date
            
        }  else{
            
            lastDate = date
            selectedVC = tempvc
            
        }
    }
}


extension MainViewController {
    
    
    func setupChildControllers()
    {
        // 判断是否登录，如果登录那么就有个人书架，如果没有登录就不添加个人书架选项
        
        var  array = [
            
            ["clsName": "RankViewController", "title": "排行榜", "imageName" : "rank"],
            
            ["clsName": "HotAndRecommendViewController", "title": "热门推荐", "imageName" : "hot"],
            ["clsName": "BaseViewController", "title": "本地书架", "imageName" : "books"],
            ["clsName": "SettingViewController", "title": "设置", "imageName" : "setting"],
            
            ]
        
        
        if userLogon {
            
            array.insert( ["clsName": "BookshelfViewController", "title": "个人书架", "imageName" : "profile"], at: 0)
            
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
        
        // vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")
        
        
        // vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes( [NSFontAttributeName: UIFont.systemFont(ofSize: 10)],  for: .normal)
        
        let nav = NavigationViewController(rootViewController: vc)
        
        return nav
        
    }
    
}
