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
    
    var loadingWindow:LoadingWidthColoseButtonView!
    
    
    var layer:CALayer!
    
    var isLoading = false {
        
        
        didSet {
            
            loadingWindow.isHidden = !isLoading
            
            setPageViewBounces(bool: !isLoading)
            
            
        }
    }
    
    var isShowMenu: Bool = false
    
    var isShowing = false
    
    var isSwitching = false
    
    var pageController:UIPageViewController = UIPageViewController()
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var btnRetry: UIButton!
    
    @IBOutlet weak var topMenu: UIView!
    
    @IBOutlet weak var botomMenu: UIView!
    
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var lightValueslider: UISlider!
    
    
    
    @IBOutlet weak var btnMinLineSpace: UIButton!
    
    @IBOutlet weak var btnMidLineSpace: UIButton!
    
    @IBOutlet weak var btnMaxLineSpace: UIButton!
    
    @IBOutlet weak var btnFontSizeMinus: UIButton!
    
    @IBOutlet weak var btnFontSizePlus: UIButton!
    
    
    @IBOutlet weak var txtFontSize: UILabel!
    
    
    
    func cancleAction() {
        
        vm.isCurrentCanclled = true
        
        vm.currentTask?.cancel()
        
        print("取消请求")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        initContentData()
        
        initCatalogs()
        
        txtBookName.text = vm.currentBook?.bookName
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettingBar), name: NSNotification.Name(rawValue: ContentPageMenuNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToPage), name: NSNotification.Name(rawValue: ContentPageSwitchNotification), object: nil)
        
    }
    
    
    // MARK: 获取当前页面数据
    func initContentData(_ isHead:Bool = true) {
        
        guard let url = vm.currentCatalog?.chapterUrl else {
            
            return
        }
        
        if let pages = vm.contentDic[url] {
            
            vm.currentChapterPageList = pages
            
            setRequestScuccess(isHead)
            
            return
            
        }
        
        self.isLoading = true
        
        self.btnRetry.isHidden = true
        
        self.errorView.isHidden = true
        
        self.vm.getCatalogContentByPosin(posion: .Current) {[weak self] (isSuccess) in
            
            if self == nil {
                
                return
            }
            
            DispatchQueue.main.async {
                
                if isSuccess {
                    
                    self?.setRequestScuccess(isHead)
                    
                    
                } else {
                    
                    self?.setRequestFailed()
                    
                }
                
                self?.loadingWindow.isHidden = true
                
                self?.isLoading = false
                
            }
            
        }
        
    }
    
    
    func setRequestScuccess(_ isHead:Bool) {
        
        
        if self.vm.currentChapterPageList == nil  {
            
            return
        }
        
        let index = isHead ? 0 : (vm.currentChapterPageList?.count)! - 1
        
        let controller:ContentPageViewController? =  self.getViewControllerByCatalog(vm.currentCatalog, index: index)
        
        if  controller != nil {
            
            DispatchQueue.main.async {
                
                let viewControllers:[ContentPageViewController] = [controller!]
                
                self.pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
                
            }
            
        }
        
    }
    
    
    func setRequestFailed() {
        
        let controller:ContentPageViewController =  (self.createEmptyContenPageController())
        
        let viewControllers:[ContentPageViewController] = [controller]
        
        self.pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
        
        self.btnRetry.isHidden = false
        
        self.errorView.isHidden = false
        
        
    }
    
    // MARK: 获取目录数据
    func  initCatalogs() {
        
        
        DispatchQueue.global().async {
            
            guard let url =   self.vm.currentBook?.contentPageUrl  else{
                
                return
            }
            /// 获取目录信息
            self.vm.getBookCatalogs(url: url,retryCount: 0, completion: { (isSucces) in
                
                DispatchQueue.main.async {
                    
                    for controller in  self.pageController.childViewControllers {
                        
                        guard  let ctr = controller as? ContentPageViewController,
                            let view = controller.view as? ContentPage,
                            let catalog = ctr.catalog,
                            let currentIndex  = self.vm.getCatalogIndex(catalog.chapterUrl!) else{
                                
                                continue
                                
                        }
                        
                        view.txtChapterIndex.text  = "第\(currentIndex + 1)/\((self.vm.currentBook?.catalogs?.count)!)章"
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    //MARK: 点击重试按钮事件
    @IBAction func retryAction(_ sender: Any) {
        
        
        errorView.isHidden = true
        
        btnRetry .isHidden = true
        
        initContentData()
    }
    
    
    // MARK: 点击关闭按钮事件
    func closeAciton() {
        
        //销毁定时器
        timer?.invalidate()
        
        vm.isCurrentCanclled = true
        vm.isPreCanclled = true
        vm.isNextCanclled = true
        vm.isCatalogCanclled = true
        
        vm.currentTask?.cancel()
        vm.preTask?.cancel()
        vm.nextTask?.cancel()
        vm.catalogTask?.cancel()
        
        loadingWindow.removeFromSuperview()
        
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
        
        //        print("准备上一页数据")
        //        var index = (viewController as! ContentPageViewController).tag
        //
        
        guard let catalog = (viewController as! ContentPageViewController).catalog else {
            
            return nil
        }
        
        var index = (viewController as! ContentPageViewController).tag
        
        index -= 1
        
        let controller:ContentPageViewController? = getViewControllerByCatalog(catalog,index: index)
        
        return controller
    }
    
    ///MARK: 准备下一页数据
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        //print("准备下一页数据")
        guard  let catalog = (viewController as! ContentPageViewController).catalog else {
            
            return nil
        }
        
        
        var index = (viewController as! ContentPageViewController).tag
        
        index += 1
        
        let controller:ContentPageViewController? = getViewControllerByCatalog((catalog),index: index)
        
        return controller
        
    }
    
    // MARK: 将要切换到下一页之前
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        // pageController.view.isUserInteractionEnabled = false
    }
    
    
    // MARK: 切换结束后
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (finished && completed) {
            
            guard  let controller = (pageViewController.viewControllers?[0] as? ContentPageViewController) ,let catalog = controller.catalog else{
                
                return
                
            }
            
            DispatchQueue.main.async {
                
                if self.vm.currentCatalog?.chapterUrl != catalog.chapterUrl {
                    
                    if controller.tag == 99  {
                        
                        self.vm.SetCurrentCatalog(catalog: catalog, completion: nil)
                        
                        self.initContentData(true)
                        
                    }  else if controller.tag == -99 {
                        
                        self.vm.SetCurrentCatalog(catalog: catalog, completion: nil)
                        
                        self.initContentData(false)
                        
                    }   else {
                        
                        self.vm.SetCurrentCatalog(catalog: catalog, completion: nil)
                    }
                }
                
                
                
                print(controller.catalog?.chapterName ?? "无章节名")
                
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
        
        guard  let catalog = controller.catalog   else{
            
            return
        }
        
        if obj.object as? String == "-1" {
            
            index -= 1
            
        } else if obj.object as? String  == "1" {
            
            index  += 1
        }
        
        
        if   let  result = getViewControllerByCatalog(catalog,index:index)  {
            
            DispatchQueue.main.async {
                
                self.vm.SetCurrentCatalog(catalog: result.catalog, completion: nil)
                
                self.pageController.setViewControllers([result], direction:.reverse, animated: false, completion: nil)
                
                if  result.tag == 99 || result.tag == -99  {
                    
                    self.vm.currentChapterPageList = nil
                    self.initContentData( (obj.object as? String == "1") ? true : false)
                    
                }
            }
            
        }
    }
    
    
    // MARK: 根据索引获取数据
    func getViewControllerByCatalog(_ cata:BookCatalog?,index:Int) -> ContentPageViewController? {
        
        guard  let catalog = cata ,let  catalogUrl = catalog.chapterUrl  else{
            
            return nil
            
        }
        
        let controller:ContentPageViewController = ContentPageViewController()
        
        controller.battery = currentBattery
        
        controller.time = currentTime
        
        controller.textAttributeDic = vm.getTextContetAttributes()
        
        controller.backColor = self.view.backgroundColor
        
        
        guard  let currentPages = vm.contentDic[catalogUrl] else {
            
            return nil
        }
        
        if currentPages.count == 0 {
            
            return nil
        }
        
        
        if index == -1 {
            
            guard let _ = vm.currentBook?.catalogs else {
                
                return nil
            }
            
            guard  var tempIndex = vm.getCatalogIndex(catalogUrl)  else {
                
                return nil
                
            }
            
            tempIndex -= 1
            
            if tempIndex  < 0 {
                
                return nil
            }
            
            guard  let catalog = vm.currentBook?.catalogs?[tempIndex]  else{
                
                // 如果没有上一章 那么返回 nil
                return nil
                
            }
            
            
            let pages = vm.contentDic[catalog.chapterUrl!]
            
            if pages != nil  && (pages?.count)! > 0 {
                
                controller.chapterName = catalog.chapterName
                
                controller.content = pages?[((pages?.count)! - 1)]
                
                controller.tag = (pages?.count)! - 1
                
                controller.pageIndex = "第\((pages?.count)!)/\((pages?.count)!)页"
                
                if let currentIndex  = vm.getCatalogIndex(catalog.chapterUrl!) {
                    
                    controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
                }
                
                controller.catalog = catalog.clone()
                
                return controller
                
            }  else {
                
                controller.chapterName = catalog.chapterName
                
                controller.catalog = catalog.clone()
                
                controller.tag = -99
                
                controller.content = " "
                
                return controller
                
            }
            
        }
        
        
        if index >= currentPages.count {
            
            guard let catalogs = vm.currentBook?.catalogs else {
                
                return nil
            }
            
            guard  var tempIndex = vm.getCatalogIndex(catalogUrl)  else {
                
                return nil
                
            }
            
            tempIndex += 1
            
            if tempIndex  >=  catalogs.count {
                
                return nil
            }
            
            guard  let catalog = vm.currentBook?.catalogs?[tempIndex]  else{
                
                // 如果没有下一章 那么返回 nil
                return nil
                
            }
            
            
            let pages = vm.contentDic[catalog.chapterUrl!]
            
            if pages != nil  && (pages?.count)! > 0 {
                
                controller.chapterName = catalog.chapterName
                
                controller.content = pages?[0]
                
                controller.tag = 0
                
                controller.pageIndex = "第\(1)/\((pages?.count)!)页"
                
                if let currentIndex  = vm.getCatalogIndex(catalog.chapterUrl!) {
                    
                    controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
                }
                
                controller.catalog = catalog.clone()
                
                return controller
                
            }  else {
                
                controller.chapterName = catalog.chapterName
                
                controller.catalog = catalog.clone()
                
                controller.tag = 99
                
                controller.content = " "
                
                return controller
                
            }
        }
        
        
        //正常切换
        if index >= 0  &&  index < currentPages.count {
            
            
            controller.chapterName = catalog.chapterName
            
            controller.content = currentPages[index]
            
            controller.tag = index
            
            controller.pageIndex = "第\(index + 1)/\(currentPages.count)页"
            
            if let currentIndex  = vm.getCatalogIndex(catalog.chapterUrl!) {
                
                controller.chapterIndex = "第\(currentIndex + 1)/\((vm.currentBook?.catalogs?.count)!)章"
            }
            
            
            controller.catalog = catalog.clone()
            
            return controller
            
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
        
        
        setPageViewBounces(bool: false)
        
        
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
        
        
        if !isLoading {
            
            setPageViewBounces(bool: true)
        }
        
        settingView.isHidden = true
        
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
        
        v.catalog = vm.currentCatalog
        
        
        v.completionBlock = { (catalog)  in
            
            
            if (self.isLoading) {
                
                
                
            }
            
            self.vm.SetCurrentCatalog(catalog: catalog, completion: nil)
            self.initContentData()
            
        }
        
        hidenMenu()
        
        present(v, animated: true, completion: nil)
        
        
        
        
    }
    
    
    // MARK: 点击缓存按钮
    func downLoadClick() {
        
        print("点击下载按钮")
        
        
        
        
    }
    
    
    //MARK: 点击设置按钮
    func settingClick() {
        
        print("点击设置按钮")
        
        settingView.isHidden = !settingView.isHidden
        
    }
    
    //MARK: 亮度调节
    func lightValueChanged(obj:UISlider) {
        
        let value = Float(Float(1) -  obj.value)
        
        layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(value)).cgColor
        
        vm.lightValue =  obj.value
    }
    
    
    //MARK: 行间距调节
    func lineSpaceValueChanged(obj:UIButton) {
        
        let index =  obj.tag
        
        vm.lineSpace =  vm.lineSpaces[index]
        
        btnMinLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[0] ? true :false
        
        btnMidLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[1] ? true :false
        
        btnMaxLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[2] ? true :false
        
        
        resetContent()
    }
    
    
    // MARK: 调整字体
    func fontSizeChanged(btn:UIButton!) {
        
        let index = btn.tag
        
        
        if index == 0 {
            
            if vm.fontSize == 16 {
                
                return
            }
            
            vm.fontSize -= 1
            
        } else {
            
            if vm.fontSize == 26 {
                
                return
            }
            
            vm.fontSize += 1
        }
        
        txtFontSize.text = String(Int(vm.fontSize))
        resetContent()
        
    }
    
    
    func resetContent() {
        
        if vm.currentCatalog?.chapterContent == nil {
            
            return
        }
        
        guard   let controller  =  self.pageController.viewControllers?[0] as? ContentPageViewController,let catalog = controller.catalog else {
            
            return
        }
        
        
        if vm.contentDic[catalog.chapterUrl!] != nil {
            
            vm.contentDic.removeValue(forKey: catalog.chapterUrl!)
            
        }
        
        
        vm.splitPages(html: catalog.chapterContent) { (pages) in
            
            self.vm.currentChapterPageList = pages
            
            self.vm.contentDic[catalog.chapterUrl!] = pages
            
            DispatchQueue.main.async {
                
                var index = controller.tag
                
                if index > (pages?.count)! - 1 {
                    
                    index = (pages?.count)! - 1
                }
                
                if  let result = self.getViewControllerByCatalog(catalog, index: index) {
                    
                    self.pageController.setViewControllers([result], direction:.reverse, animated: false, completion: nil)
                    
                }
                
            }
            
        }
        
    }
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    // MARK: 初始化界面
    func setupUI() {
        
        UIApplication.shared.isStatusBarHidden = true
        
        self.view.frame = UIScreen.main.bounds
        
        errorView?.isHidden = true
        
        topMenu.isHidden = true
        
        botomMenu.isHidden = true
        
        btnRetry.isHidden = true
        
        
        setBottonBarButton()
        
        setPageViewController()
        
        setupLoadingView()
        
        setColor()
        
        setTiemInfo()
        
        setBattaryInfo()
        
        setupSettingPanel()
        
    }
    
    
    
    
    
    
    //MARK: 设置加载指示器
    func setupLoadingView() {
        
        loadingWindow =  LoadingWidthColoseButtonView.loadingWidthColoseButtonView()
        
        loadingWindow.btnClose.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        
        loadingWindow.isHidden = true
        
        loadingWindow.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
        
        self.view.insertSubview(loadingWindow, at: self.view.subviews.count)
        
    }
    
    // MARK: 初始化PageViewController
    func setPageViewController() {
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: vm.orientation, options: nil)
        
        pageController.dataSource = self
        
        pageController.delegate = self
        
        pageController.view.backgroundColor = UIColor.clear
//        
//        if vm.orientation == .vertical {
//            
//            for v in  pageController.view.subviews {
//                
//                if v.isKind(of:UIScrollView.self) {
//                    
//                    (v as! UIScrollView).isPagingEnabled = false
//                    
//                }
//                
//            }
//        }
//        
        
        
        
        let viewControllers:[ContentPageViewController] = [createEmptyContenPageController()]
        
        pageController.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: nil)
        
        pageController.view.frame = self.view.bounds
        
        self.addChildViewController(pageController)
        
        self.view.insertSubview(pageController.view, at: 0)
        
        
        
        
    }
    
    
    // MARK:设置禁用，或开启反弹效果
    
    func setPageViewBounces(bool:Bool) {
        
        for v in  self.pageController.view.subviews {
            
            if v.isKind(of:UIScrollView.self) {
                
                (v as! UIScrollView).bounces = bool
                
                (v as! UIScrollView).isScrollEnabled = bool
                
            }
            
        }
        
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
            
            guard  let controllers = pageController.viewControllers else  {
                
                return
                
            }
            
            for item in controllers {
                
                guard  let  page = item as? ContentPageViewController  else {
                    
                    continue
                }
                
                page.contPage?.txtBattery.text = currentBattery
                
            }
            
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
            
            currentTime  = dateString
            
            guard  let controllers = pageController.viewControllers else  {
                
                return
                
            }
            
            for item in controllers {
                
                guard  let  page = item as? ContentPageViewController  else {
                    
                    continue
                }
                
                DispatchQueue.main.async {
                    
                    page.contPage?.txtTime.text = dateString
                    
                }
                
            }
            
        }
        
    }
    
    
    
    // MARK: 设置底部菜单
    func setBottonBarButton() {
        
        /// 按钮数据数组
        let buttonsInfo = [["imageName": "content_bar_moonlight", "title": "夜间"],
                           ["imageName": "content_bar_mulu", "title": "目录","className":"className","actionName" : "muluClick"],
                           ["imageName": "content_bar_download", "title": "缓存","actionName" : "downLoadClick"],
                           ["imageName": "content_bar_setting", "title": "设置","actionName" :  "settingClick"],
                           ]
        
        
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
        
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        
    }
}


extension BookContentViewController {
    
    //MARK: 初始化设置面板
    func setupSettingPanel() {
        
        settingView.isHidden = true
        
        setupCALayer()
        
        setupSlider()
        
        setupFontSizeButton()
        
        setupLineSpaceButton()
        
        txtFontSize.text = String(Int(vm.fontSize))
        
    }
    
    /// MARK: 设置slider
    func setupSlider() {
        
        lightValueslider.setThumbImage(UIImage(named: "slider"), for: .normal)
        
        lightValueslider.addTarget(self, action: #selector(lightValueChanged), for: .valueChanged)
        
        lightValueslider.value = vm.lightValue
        
        
    }
    
    
    // MARK: 设置遮罩
    func setupCALayer()  {
        
        layer = CALayer()
        
        layer.frame = UIScreen.main.bounds
        
        let value =  Float(1) -  vm.lightValue
        
        layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(value)).cgColor
        
        self.view.layer.addSublayer(layer)
        
    }
    
    
    // MARK: 设置字体加减按钮
    func setupFontSizeButton()  {
        
        let array:[UIButton]! = [btnFontSizeMinus,btnFontSizePlus]
        
        for  (i,btn) in array.enumerated() {
            
            btn.layer.cornerRadius = 5
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.white.cgColor
            btn.layer.masksToBounds = true
            btn.backgroundColor = UIColor.clear
            btn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: UIControlState.normal)
            btn.setBackgroundImage(UIImage.imageWithColor(color:  UIColor(red:19.0/255.0, green: 19.0/255.0, blue:19.0/255.0, alpha: 1)), for: UIControlState.highlighted)
            btn.tag = i
            btn.addTarget(self, action: #selector(fontSizeChanged), for: .touchUpInside)
        }
        
        
    }
    
    
    // MARK: 行高按钮
    func setupLineSpaceButton()  {
        
        let array:[UIButton]! = [btnMinLineSpace,btnMidLineSpace,btnMaxLineSpace]
        
        for (i,btn) in array.enumerated() {
            
            btn.layer.cornerRadius = 5
            btn.layer.borderWidth = 1.0
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.white.cgColor
            btn.backgroundColor = UIColor.clear
            btn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: UIControlState.normal)
            
            btn.setBackgroundImage(UIImage.imageWithColor(color: UIColor(red:19.0/255.0, green: 19.0/255.0, blue:19.0/255.0, alpha: 1)), for: UIControlState.highlighted)
            
            btn.tag = i
            
            btn.addTarget(self, action: #selector(lineSpaceValueChanged), for: .touchUpInside)
            
        }
        
        btnMinLineSpace.setImage( UIImage(named: "lineSpace_min_selected"), for: .selected)
        btnMinLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[0] ? true :false
        
        btnMidLineSpace.setImage( UIImage(named: "lineSpace_mid_selected"), for: .selected)
        btnMidLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[1] ? true :false
        
        btnMaxLineSpace.setImage( UIImage(named: "lineSpace_max_selected"), for: .selected)
        btnMaxLineSpace.isSelected = vm.lineSpace == vm.lineSpaces[2] ? true :false
        
        
        
    }
    
}




