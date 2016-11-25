//
//  BookContentViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

let touchBeginNotification = "touchBeginNotification"

class BookContentViewController: UIViewController {
    
    let vm = BookContentPageViewModel()
    
    var timer:Timer?
    
    var currentTime:String?
    
    var currentBattery:String?
    
    var loadingWindow:UIWindow!
    
    var isLoading = false
    
    var isShowMenu: Bool = false
    
    var isShowing = false
    
    var pageController:UIPageViewController!
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var btnRetry: UIButton!
    
    @IBOutlet weak var topMenu: UIView!
    @IBOutlet weak var botomMenu: UIView!
    
    
    /// 按钮数据数组
    let buttonsInfo = [["imageName": "content_bar_moonlight", "title": "夜间"],
                       ["imageName": "content_bar_mulu", "title": "目录","className":"className","actionName" : "muluClick"],
                       ["imageName": "content_bar_download", "title": "缓存","actionName" : "downLoadClick"],
                       ["imageName": "content_bar_setting", "title": "设置","actionName" :  "settingClick"],
                       ]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        initContentData()
        
        txtBookName.text = vm.currentBook?.bookName
        
        initCatalogs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettingBar), name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
        
    }
    
    
    
    func initContentData() {
        
        loadingWindow.isHidden = false
        
        guard let url = vm.currentCatalog?.chapterUrl else{
            
            return
        }
        
        DispatchQueue.global().async {
            
            self.vm.getCuttentChapterContent(url) { [weak self] (isSuccess) in
                
                DispatchQueue.main.async {
                    
                    if  isSuccess {
                        
                        let controller:ContentPageViewController =  (self?.getViewControllerByIndex(0))!
                        
                        let viewControllers:[ContentPageViewController] = [controller]
                        
                        self?.pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
                        
                        
                        self?.btnRetry .isHidden = true
                        self?.errorView.isHidden = true
                        
                        
                    } else {
                        
                        //  self?.btnRetry .isHidden = true
                        //  self?.errorView.isHidden = true
                        
                    }
                    
                    self?.loadingWindow.isHidden = true
                }
                
            }
            
        }
    }
    
    
    func  initCatalogs(_ completion: ((_ isSuccess:Bool)->())? = nil) {
        
        DispatchQueue.global().async {
            
            guard let url =   self.vm.currentBook?.contentPageUrl  else{
                
                return
            }
            /// 获取目录信息
            self.vm.getBookCatalogs(url: url, completion: completion)
            
        }
        
    }
    
    @IBAction func retryAction(_ sender: Any) {
        
        
        errorView.isHidden = true
        
        btnRetry .isHidden = true
        
        initContentData()
    }
    
    @IBAction func closeAciton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}

extension BookContentViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    ///上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        var index = (viewController as! ContentPageViewController).tag
        
        index -= 1
        
        let controller:ContentPageViewController? = getViewControllerByIndex(index)
        
        return controller
    }
    
    ///下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        var index = (viewController as! ContentPageViewController).tag
        
        index += 1
        
        let controller:ContentPageViewController? = getViewControllerByIndex(index)
        
        return controller
        
    }
    
    
    
    func getViewControllerByIndex(_ index:Int) -> ContentPageViewController? {
        
        
        guard let contentList = vm.currentChapterPageList,let catalog = vm.currentCatalog else {
            
            return nil
            
        }
        
        if index >= 0 && index  < contentList.count {
            
            let controller:ContentPageViewController = ContentPageViewController()
            
            controller.chapterName = catalog.chapterName
            
            controller.content = contentList[index]
            
            controller.battery = currentBattery
            
            controller.time = currentTime
            
            controller.tag = index
            
            controller.textAttributeDic = vm.getTextContetAttributes()
            
            controller.view.backgroundColor = self.view.backgroundColor
            
            return controller
            
        } else {
            
            guard let nextChapterContentList = vm.nextChapterPageList,let nextChapterCatalog = vm.currentCatalog else {
                
                return nil
                
            }
            
            return nil
            
        }
        
    }
    
    
    
    
}


// MARK: - 设置相关
extension BookContentViewController {
    
    
    ///触摸屏幕时，控制菜单的显隐（一般都是隐藏）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isShowMenu {
            
            guard  let p = touches.first?.location(in: self.view)  else{
                
                return
            }
            
            let height = self.view.bounds.height
            let width = self.view.bounds.width
            
            if p.x > width * 1 / 3 && p.x < width * 2 / 3  &&  p.y > height * 1 / 3 && p.y < height * 2 / 3  {
                
                showSettingBar()
                
            }
        }
        
    }
    
    
    /// 设置菜单显隐
    func  showSettingBar() {
        
        if isShowing {
            
            return
        }
        
        isShowing = true
        
        if !isShowMenu {
            
            showMenu()
            
        } else {
            
            hidenMenu()
        }
    }
    
    func showMenu() {
        
        if isShowMenu {
            
            return
        }
        
        isShowMenu = true
        
        self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
        
        self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
        
        
        self.topMenu.isHidden = false
        
        self.botomMenu.isHidden = false
        
        // txtContent.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.topMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.botomMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            
        }, completion: { (isSucess) in
            
            // UIApplication.shared.isStatusBarHidden = false
            
            self.isShowing = false
            
        })
        
    }
    
    
    func hidenMenu() {
        
        if !isShowMenu  {
            
            return
        }
        
        isShowMenu = false
        
        // txtContent.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
            
            self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
            
            
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
            
            
        }, completion: { (isSuccess) in
            
            self.topMenu.isHidden = true
            
            self.botomMenu.isHidden = true
            
            self.isShowing = false
        })
    }
    
    
    
    
    func  setMoonlightMode(_ btn:SettingButton) {
        
        vm.isMoomlightMode = !vm.isMoomlightMode
        
        let imageName =  vm.isMoomlightMode ? "content_bar_dayLight" : "content_bar_moonlight"
        let title = vm.isMoomlightMode ? "日间" : "夜间"
        
        btn.imageView?.image = UIImage(named:   imageName)
        btn.titleLabel?.text = title
        
        setColor()
    }
    
    
    /// 点击目录
    func muluClick() {
        
        print("点击目录")
        
        if vm.isRequestCatalogs {
            
            showToast(content: "正在获取目录，请稍后")
            return
        }
        
        
        if vm.currentBook?.catalogs == nil  || (vm.currentBook?.catalogs?.count)! == 0 {
            
            showToast(content: "暂无目录，请换个来源网站重试",false)
            return
        }
        
        let v  = BookCatalogViewController()
        
        v.book = vm.currentBook
        
        
        v.completionBlock = { [weak self] (catalog)  in
            
            self?.vm.currentCatalog = catalog
            
            self?.initContentData()
            
            self?.hidenMenu()
            
        }
        
        present(v, animated: true, completion: nil)
        
        
    }
    
    
    //点击缓存
    func downLoadClick() {
        
        print("点击下载按钮")
        
        
    }
    
    
    //点击设置
    func settingClick() {
        
        print("点击设置按钮")
        
    }
    
    
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    /// 初始化界面ui
    func setupUI() {
        
        UIApplication.shared.isStatusBarHidden = true
        
        errorView?.isHidden = true
        
        topMenu.isHidden = true
        
        botomMenu.isHidden = true
        
        btnRetry.isHidden = true
        
        loadingWindow = ToastView.instance.createLoadingView()
        
        setBattaryInfo()
        
        setTiemInfo()
        
        setBottonBarButton()
        
        setPageViewController()
        
        setColor()
        
    }
    
    
    
    func setPageViewController() {
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageController.dataSource = self
        
        pageController.delegate = self
        
        pageController.view.backgroundColor = UIColor.clear
        
        let controller:ContentPageViewController = ContentPageViewController()
        
        let viewControllers:[ContentPageViewController] = [controller]
        
        pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
        
        pageController.view.frame = self.view.bounds
        
        self.addChildViewController(pageController)
        
        self.view.insertSubview(pageController.view, at: 0)
        
        
        
    }
    
    
    
    func  setColor() {
        
        if vm.isMoomlightMode {
            
            self.view.backgroundColor =  vm.moonlightBackColor
            
        } else {
            
            self.view.backgroundColor =  vm.daylightBackColor
            
        }
        
        
        
        for controller in  self.pageController.childViewControllers {
            
            guard  let ctr = controller as? ContentPageViewController, let view = controller.view  else{
                
                continue
                
            }
            
            view.backgroundColor =  self.view.backgroundColor
            
            ctr.setTextAttribute(self.vm.getTextContetAttributes())
            
        }
        
        
    }
    
    
    /// 设置电池信息
    func setBattaryInfo() {
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(battaryChanged), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
        battaryChanged()
    }
    
    
    func battaryChanged()  {
        
        if Int(UIDevice.current.batteryLevel) == -1 {
            
            currentBattery = "电量:加载中"
            
        } else {
            
            currentBattery = "电量:\(Int(UIDevice.current.batteryLevel*100))%"
        }
        
    }
    
    
    
    
    
    /// 设置显示时间
    func setTiemInfo() {
        
        if timer == nil {
            
            timer =  Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(setTiemInfo), userInfo: nil, repeats: true)
            
            timer?.fire()
            
        } else {
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "HH:mm"
            
            let dateString = formatter.string(from: Date())
            
            currentTime = dateString
        }
        
    }
    
    
    
    /// 设置底部菜单
    func setBottonBarButton() {
        
        for (i,btn) in botomMenu.subviews.enumerated() {
            
            guard  let settingBtn = btn as? SettingButton else {
                
                continue
            }
            
            let dic =  buttonsInfo[i]
            
            
            guard  let imageName = dic["imageName"] ,let title = dic["title"] else {
                
                continue
            }
            
            
            settingBtn.imageView?.image =  UIImage(named:imageName  )
            
            settingBtn.titleLabel?.text = title
            
            if let actionName = dic["actionName"]  {
                
                settingBtn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
                
            } else {
                
                settingBtn.addTarget(self, action: #selector(setMoonlightMode), for: .touchUpInside)
            }
            
            
        }
        
    }
    
    

    
    
    /// 页面即将消失时
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        self.loadingWindow.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = false
        
        timer?.invalidate()
        
    }
    
    
}




