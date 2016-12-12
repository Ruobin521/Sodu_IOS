//
//  BaseViewController.swift
//  小说搜索阅读
//1
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BaseViewController: BaseUIViewController {
    
    
    var isLoading = false  {
        
        
        didSet {
            
            if isLoading {
                
                // setTitleView()
                
                refreshControl?.beginRefreshing()
                
            } else {
                
                navItem.titleView = nil
                
                refreshControl?.endRefreshing()
                
            }
        }
        
    }
    
    
    var isPullup = false
    
    var needPullUp = false
    
    var tableview:UITableView?
    
    var refreshControl:RefreshControl?
    
    var failedLayer:CALayer?
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //取消自动缩进
        automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
        
        initData()
        
    }
    
    
    override var title: String? {
        
        didSet {
            
            navItem.title = title
            
        }
        
    }
    
    
    /// 加载数据
    func loadData()  {
        
        refreshControl?.endRefreshing()
        
    }
    
    
    func  checkIsLoading() -> Bool {
        
        
        if  isLoading  {
            
            showToast(content: "数据加载正在努力加载中")
            
            return true
        }
        
        return false
    }
    
    
    
    func initData()  {
        
        refreshControl?.endRefreshing()
        
    }
    
    
    ///滚到顶部
    func goToTop() {
        
        if  tableview == nil  {
            
            return
        }
        
        if tableview?.numberOfSections == 0 {
            
            return
        }
        
        if (tableview?.numberOfRows(inSection: (tableview?.numberOfSections)! - 1))!  <= 0 {
            
            return
        }
        
        
        if  (tableview?.contentOffset.y)! > CGFloat(0) {
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            self.tableview?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            //                self.loadData()
            //
            //                let y = (refreshControl?.frame.height)! +  (tableview?.contentInset.top)!
            //
            //                self.tableview?.setContentOffset(CGPoint(x: 0, y: -y), animated: true)
            
        } else  {
            
            let lastSectionIndex = (tableview?.numberOfSections)! - 1
            
            if lastSectionIndex >= 0 {
                
                let latRowIndex =  (tableview?.numberOfRows(inSection: lastSectionIndex))! - 1
                
                let indexPath = IndexPath(row: latRowIndex, section: lastSectionIndex)
                
                if latRowIndex >= 0 {
                    
                    tableview?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
                
            }
            
            
        }
        
        
    }
    
    
    func endLoadData() {
        
        
        isLoading = false
        
        isPullup = false
        
    }
    
    
}

extension BaseViewController {
    
    func setupUI()  {
        
        setBackColor()
        setUpNavigationBar()
        setupTableview()
        setRefreshControl()
        
    }
    
    
    func setupTableview() -> () {
        
        tableview = UITableView(frame:  view.bounds, style: .grouped)
        
        tableview?.dataSource = self
        tableview?.delegate = self
        
        tableview?.backgroundColor =  UIColor.clear
        
        tableview?.separatorStyle = .singleLine
        
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 44, right: 0)
        
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tableview?.scrollIndicatorInsets = tableview!.contentInset
        
        tableview?.tableHeaderView = UIView(frame: CGRect(x: CGFloat( 0.0), y: CGFloat( 0.0), width:CGFloat( 0.0), height: CGFloat.leastNormalMagnitude))
        
        tableview?.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNormalMagnitude))
        
        tableview?.sectionFooterHeight = 8
        tableview?.sectionHeaderHeight = 0.1
        //  tableview?.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
        view.insertSubview(tableview!, belowSubview: navigationBar)
        
        
    }
    
    
    func setRefreshControl() {
        
        refreshControl = RefreshControl()
        
        refreshControl?.tintColor = SoDuDefaultTinkColor
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableview?.addSubview(refreshControl!)
        
        
    }
    
    func setUpNavigationBar()   {
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        
        navigationBar.barTintColor =  SoDuDefaultTinkColor
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationBar.tintColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
    }
    
    func setupSeachItem() {
        
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_discover"), style: .plain, target: self, action: #selector(goToSearchPage))
    }
    
    
    
    func  setTitleView()  {
        
        
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.frame = CGRect(x: 0, y: 32 - 3, width: 6, height: 6)
        
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = navigationBar.tintColor
        
        let size = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat(MAXFLOAT)))
        label.frame = CGRect(x: 15, y: 32 - size.height/2, width: size.width>250 ? 250 : size.width, height: size.height)
        
        label.textAlignment = .left
        
        
        
        let view  = UIView(frame: CGRect(x: 0, y: 0, width: label.frame.width + 30, height: 64))
        
        view.addSubview(label)
        view.addSubview(loadingIndicatorView)
        
        view.sizeToFit()
        
        self.navItem.titleView = view
        
    }
    
    
    func setupFailedView() {
 
        failedLayer = CALayer()
        
        failedLayer?.isHidden = true
        
        let failedView = FailedView.failedView()
        
        let view = UIView(frame: self.view.frame)
        
        view.addSubview(failedView)
        
        failedView.center = CGPoint(x: view.center.x, y: view.center.y -  100)
                 
        failedLayer?.contents =  UIImage.convertViewToImage(view: view).cgImage
        
        failedLayer?.anchorPoint =  CGPoint.zero
        
        
        failedLayer?.bounds =  CGRect(x: 0, y: 0, width: (view.frame.width), height: (view.frame.height))
       
        failedLayer?.frame = (failedLayer?.frame)!
  
        tableview?.layer.addSublayer(failedLayer!)
        
        failedLayer?.zPosition = -5
   
    }
    
    
    
    func  setBackColor()  {
        
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    }
    
    
    
    
    func goToSearchPage() {
        
        let vc = SearchViewController()
        
        vc.title = "搜索"
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
}

///实现数据源代理方法，父类不实现具体方法，子类去实现，子类调用不需要使用super
extension BaseViewController :UITableViewDataSource,UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 95
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    
    /// 主要是上拉加载
    ///
    /// - parameter tableView: <#tableView description#>
    /// - parameter cell:      <#cell description#>
    /// - parameter indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if !needPullUp {
            
            return
        }
        
        
        var result = false
        
        let section = indexPath.section
        
        let row = indexPath.row
        
        let sectionCount  =  tableView.numberOfSections
        
        let rowCount = tableView.numberOfRows(inSection: section)
        
        if sectionCount > 1 {
            
            if (section == sectionCount - 1) && !isPullup && needPullUp && !isLoading {
                
                result = true
            }
        } else if sectionCount == 1 {
            
            if (row == rowCount - 1) && !isPullup && needPullUp && !isLoading {
                
                result = true
            }
            
        }
        
        if result {
            
            isPullup = true
            loadData()
            
        }
        
    }
    
    
    
    /// 设置section的标题
    ///
    /// - parameter tableView: <#tableView description#>
    /// - parameter section:   <#section description#>
    ///
    /// - returns: <#return value description#>
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil
    }
    
    ///选中后取消选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        return nil
    }
    
}





extension UIViewController {
    
    
    func showToast(content:String,_ isScuccess:Bool = true,_ isCenter :Bool = false) {
        
        DispatchQueue.main.async {
            
            self.view.addSubview(ToastView.instance.showToast(content: content,isScuccess,isCenter))
            
        }
        
    }
    
    
}
