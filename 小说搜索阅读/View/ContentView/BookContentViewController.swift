//
//  BookContentViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit




class BookContentViewController: UIViewController {
    
    let vm = BookContentPageViewModel()
    
    var timer:Timer?
    
    var currentTime:String?
    
    var currentBattery:String?
    
    var loadingWindow:UIWindow!
    
    var isLoading = false
    
    var isShowMenu: Bool = false
    
    var isShowing = false
    
    var isSwitching = false
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettingBar), name: NSNotification.Name(rawValue: contentPageMenuNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToPage), name: NSNotification.Name(rawValue: contentPageSwitchNotification), object: nil)
        
    }
    
    
    // MARK: 获取当前页面数据
    func initContentData() {
        
        loadingWindow.isHidden = false
        
        DispatchQueue.global().async {
            
            self.vm.getCatalogChapterContent(catalog: self.vm.currentCatalog){ [weak self] (isSuccess, html) in
                
                DispatchQueue.main.async {
                    
                    if  isSuccess {
                        
                        self?.vm.currentChapterPageList = self?.vm.splitPages(html: html)
                        
                        let controller:ContentPageViewController =  (self?.getViewControllerByIndex(0))!
                        
                        let viewControllers:[ContentPageViewController] = [controller]
                        
                        self?.pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
                        
                    } else {
                        
                        
                        let controller:ContentPageViewController =  (self?.createEmptyContenPageController())!
                        
                        let viewControllers:[ContentPageViewController] = [controller]
                        
                        self?.pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
                        
                        self?.btnRetry .isHidden = false
                        self?.errorView.isHidden = false
                        
                    }
                    
                    self?.loadingWindow.isHidden = true
                }
                
            }
            
        }
    }
    
    
    // MARK: 获取目录数据
    func  initCatalogs(_ completion: ((_ isSuccess:Bool)->())? = nil) {
        
        DispatchQueue.global().async {
            
            guard let url =   self.vm.currentBook?.contentPageUrl  else{
                
                return
            }
            /// 获取目录信息
            self.vm.getBookCatalogs(url: url,retryCount: 0, completion: completion)
            
        }
        
    }
    
    //MARK: 点击重试按钮事件
    @IBAction func retryAction(_ sender: Any) {
        
        
        errorView.isHidden = true
        
        btnRetry .isHidden = true
        
        initContentData()
    }
    
    
    // MARK: 点击关闭按钮事件
    @IBAction func closeAciton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:  析构函数
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}



// MARK: - 页面切换 代理 数据
extension BookContentViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    // MARK: 准备上一页数据
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        var index = (viewController as! ContentPageViewController).tag
        
        index -= 1
        
        let controller:ContentPageViewController? = getViewControllerByIndex(index)
        
        return controller
    }
    
    ///MARK: 准备下一页数据
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        var index = (viewController as! ContentPageViewController).tag
        
        index += 1
        
        let controller:ContentPageViewController? = getViewControllerByIndex(index)
        
        return controller
        
    }
    
    // MARK: 将要切换到下一页之前
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // pageController.view.isUserInteractionEnabled = false
    }
    
    
    // MARK: 切换结束后
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed && finished) {
            
            // pageController.view.isUserInteractionEnabled = true
            
            let precontroller = previousViewControllers[0] as? ContentPageViewController
            
            let currentController = pageViewController.viewControllers?[0] as? ContentPageViewController;
            
            if currentController?.catalog?.chapterUrl !=  precontroller?.catalog?.chapterUrl {
                
                vm.SetCurrentCatalog(catalog: currentController?.catalog, completion: nil)
                
            }
            
        }
        
    }
    
    
    
    // MARK: 点击前后切换
    func moveToPage(obj:NSNotification) {
        
        if vm.orientation == .vertical   || isShowMenu {
            
            return
        }
        
        guard   let controller  =  pageController.viewControllers?[0] as? ContentPageViewController else {
            
            return
        }
        
        
        
        var index:Int = controller.tag
        
        if obj.object as? String == "-1" {
            
            index -= 1
            
        } else if obj.object as? String  == "1" {
            
            index  += 1
        }
        
        
        if   let  result = getViewControllerByIndex(index)
        {
            let direction = (obj.object as? String == "1") ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse
            
            vm.SetCurrentCatalog(catalog: result.catalog, completion: nil)
            pageController.setViewControllers([result], direction:direction, animated: false, completion: nil)
            
            
            
        }
    }
    
    
    // MARK: 根据索引获取数据
    func getViewControllerByIndex(_ index:Int) -> ContentPageViewController? {
        
        
        guard let currentList =  vm.currentChapterPageList else{
            
            return  nil
            
        }
        
        let controller:ContentPageViewController = ContentPageViewController()
        
        controller.battery = currentBattery
        
        controller.time = currentTime
        
        controller.textAttributeDic = vm.getTextContetAttributes()
        
        controller.backColor = self.view.backgroundColor
        
        
        
        //当前章节正常切换
        if index >= 0  &&  index < currentList.count {
            
            guard let catalog = vm.currentCatalog else {
                
                return nil
                
            }
            
            
            controller.chapterName = catalog.chapterName
            
            controller.content = currentList[index]
            
            controller.tag = index
            
            controller.pageIndex = "第\(index + 1)/\(currentList.count)页"
            
            if let currentIndex  = vm.getCatalogIndex(catalog) {
                
                controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
            }
            
            
            controller.catalog = catalog.clone()
            
            return controller
            
        }
            
            //需要切换到下一章
        else  if index == currentList.count {
            
            
            guard  let next = vm.getCatalogByPosion(posion: .Next)  else{
                
                // 如果没有下一章 那么返回 nil
                return nil
                
            }
            
            
            //如果有下一章
            
            // 1 先判断下一章的数据是否存在
            
            /// 1.1 如果存在,直接取数据,并赋值
            if vm.nextChapterPageList != nil && (vm.nextChapterPageList?.count)! > 0 {
                
                let nextList = vm.nextChapterPageList!
                
                controller.chapterName = next.chapterName
                
                controller.content = nextList[0]
                
                controller.tag = 0
                
                controller.catalog = next.clone()
                
                controller.pageIndex = "第\(1)/\(nextList.count)页"
                
                if let currentIndex  = vm.getCatalogIndex(next) {
                    
                    controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
                }
                
                return controller
                
            }
                /// 1.2 数据不存在，那么需要去请求数据
            else {
                
                
                
                
            }
            
        }
            
            ///需要切换到上一章
        else if index == -1 {
            
            guard  let catalog = vm.getCatalogByPosion(posion: .Before)  else{
                
                // 如果没有上一章 那么返回 nil
                return nil
                
            }
            
            //如果有上一章
            
            // 1 先判断上一章的数据是否存在
            
            /// 1.1 如果存在,直接取数据,并赋值
            if vm.preChapterPageList != nil && ( vm.preChapterPageList?.count)! > 0 {
                
                let preList =  vm.preChapterPageList!
                
                let currentTag = preList.count - 1
                
                controller.chapterName = catalog.chapterName
                
                controller.content = preList[currentTag]
                
                controller.tag =  currentTag
                
                controller.catalog = catalog.clone()
                
                controller.pageIndex = "第\(currentTag + 1)/\(preList.count)页"
                
                if let currentIndex  = vm.getCatalogIndex(catalog) {
                    
                    controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
                }
                
                return controller
                
            }
                /// 1.2 数据不存在，那么需要去请求数据
            else {
                
                
                
                
            }
            
        }
        
        return nil
    }
    
    
    
    
    //MARK: 创建空白数据页
    func createEmptyContenPageController()  -> ContentPageViewController{
        
        
        let controller:ContentPageViewController = ContentPageViewController()
        
        controller.battery = currentBattery
        
        controller.time = currentTime
        
        controller.chapterName = vm.currentCatalog?.chapterName ?? ""
        
        controller.textAttributeDic = vm.getTextContetAttributes()
        
        return controller
        
    }
    
    
}


// MARK: - 设置相关
extension BookContentViewController {
    
    
    //    //MARK: 触摸屏幕时，控制菜单的显隐（一般都是隐藏）
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        if isShowMenu {
    //
    //            guard  let p = touches.first?.location(in: self.view)  else{
    //
    //                return
    //            }
    //
    //            let height = self.view.bounds.height
    //            let width = self.view.bounds.width
    //
    //            if p.x > width * 1 / 3 && p.x < width * 2 / 3  &&  p.y > height * 1 / 3 && p.y < height * 2 / 3  {
    //
    //                showSettingBar()
    //
    //            }
    //        }
    //
    //    }
    
    
    // MARK: 设置菜单显隐
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
    
    
    // MARK: 显示菜单
    func showMenu() {
        
        if isShowMenu {
            
            return
        }
        
        isShowMenu = true
        
        self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
        
        self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
        
        
        self.topMenu.isHidden = false
        
        self.botomMenu.isHidden = false
        
        
        
        for v in  self.pageController.view.subviews {
            
            if v.isKind(of:UIScrollView.self) {
                
                (v as! UIScrollView).isScrollEnabled = false
                
            }
            
        }
        
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.topMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.botomMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: { (isSucess) in
            
            self.isShowing = false
            
            
        })
        
    }
    
    // MARK: 隐藏菜单
    func hidenMenu() {
        
        if !isShowMenu  {
            
            return
        }
        
        isShowMenu = false
        
        
        for v in  self.pageController.view.subviews {
            
            if v.isKind(of: UIScrollView.self) {
                
                (v as! UIScrollView).isScrollEnabled = true
                
            }
            
        }
        
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
            
            self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
            
            
        }, completion: { (isSuccess) in
            
            self.topMenu.isHidden = true
            
            self.botomMenu.isHidden = true
            
            self.isShowing = false
            
        })
    }
    
    
    //MARK:  日间、夜间模式切换
    func  setMoonlightMode(_ btn:SettingButton) {
        
        vm.isMoomlightMode = !vm.isMoomlightMode
        
        let imageName =  vm.isMoomlightMode ? "content_bar_dayLight" : "content_bar_moonlight"
        let title = vm.isMoomlightMode ? "日间" : "夜间"
        
        btn.imageView?.image = UIImage(named:   imageName)
        btn.titleLabel?.text = title
        
        setColor()
    }
    
    
    // MARK: 点击目录按钮
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
            
            self?.vm.SetCurrentCatalog(catalog: catalog, completion: nil)
            self?.initContentData()
            
         }
        
        present(v, animated: true, completion: nil)
        
        hidenMenu()
        
        
    }
    
    
    // MARK: 点击缓存按钮
    func downLoadClick() {
        
        print("点击下载按钮")
        
        
    }
    
    
    //MARK: 点击设置按钮
    func settingClick() {
        
        print("点击设置按钮")
        
    }
    
    
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    // MARK: 初始化界面
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
    
    
    // MARK: 初始化PageViewController
    func setPageViewController() {
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageController.dataSource = self
        
        pageController.delegate = self
        
        pageController.view.backgroundColor = UIColor.clear
        
        let viewControllers:[ContentPageViewController] = [createEmptyContenPageController()]
        
        pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
        
        pageController.view.frame = self.view.bounds
        
        self.addChildViewController(pageController)
        
        self.view.insertSubview(pageController.view, at: 0)
        
    }
    
    
    // MARK: 初始化颜色
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
    
    
    // MARK: 设置电池信息
    func setBattaryInfo() {
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(battaryChanged), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
        battaryChanged()
    }
    
    
    // MARK: 电池信息发生变化时，处理当前显示
    func battaryChanged()  {
        
        if Int(UIDevice.current.batteryLevel) == -1 {
            
            currentBattery = "电量:加载中"
            
        } else {
            
            currentBattery = "电量:\(Int(UIDevice.current.batteryLevel*100))%"
        }
        
    }
    
    
    
    
    
    // MARK: 设置显示时间
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
    
    
    
    // MARK: 设置底部菜单
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
    
    
    
    
    
    // MARK: 页面即将消失时
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        self.loadingWindow.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = false
        
        timer?.invalidate()
        
    }
    
    
}




