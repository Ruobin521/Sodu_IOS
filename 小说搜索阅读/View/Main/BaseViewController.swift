//
//  BaseViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    var isLoading = false
    
    weak var processWindow:UIWindow?
    
    var isPullup = false
    
    var needPullUp = false
    
    var tableview:UITableView?
    
    var refreshControl:UIRefreshControl?
    
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
    
        refreshControl?.endRefreshing()
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中")
            
            return true
        }
        
        return false
    }
    
    
    
    func initData()  {
        
        
    }
    
    
    ///滚到顶部
    func goToTop() {
        
        if  tableview == nil  {
            
            return
        }
        
        
        if   (tableview?.numberOfRows(inSection: 0))! > 0 {
            
            if  (tableview?.contentOffset.y)! > CGFloat(0) {
                
                let indexPath = IndexPath(row: 0, section: 0)
                
                self.tableview?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
                
                
                
            } else {
                
                let lastSectionIndex = (tableview?.numberOfSections)! - 1
                
                let latRowIndex =  (tableview?.numberOfRows(inSection: lastSectionIndex))! - 1
                
                let indexPath = IndexPath(row: latRowIndex, section: lastSectionIndex)
                
                tableview?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            }
        }
        
    }
    
    
    func endLoadData() {
        
        refreshControl?.endRefreshing()
        
        if processWindow != nil {
            
            ToastView.instance.removeToast(sender: processWindow)
            
            self.processWindow = nil
        }
        
        
        isLoading = false
        
        isPullup = false
        
    }
    
    
}

extension BaseViewController {
    
    func setupUI() -> () {
        
        setBackColor()
        setUpNavigationBar()
        setuoTableview()
        
    }
    
    
    func setuoTableview() -> () {
        
        tableview = UITableView(frame:  view.bounds, style: .grouped)
        
        tableview?.dataSource = self
        tableview?.delegate = self
        
        tableview?.backgroundColor = UIColor.white
        
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.tintColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableview?.addSubview(refreshControl!)
        
        
        tableview?.sectionFooterHeight = 10
        
        tableview?.tableHeaderView = UIView(frame: CGRect(x: CGFloat( 0.0), y: CGFloat( 0.0), width:CGFloat( 0.0), height: CGFloat(5)))
        
        tableview?.rowHeight = 68
        
        view.insertSubview(tableview!, belowSubview: navigationBar)
        
    }
    
    
    func setUpNavigationBar()   {
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        
        navigationBar.barTintColor = self.view.tintColor
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
        
    }
    
    
    
    func  setBackColor()  {
        
        view.backgroundColor = UIColor.white
    }
    
    
}

///实现数据源代理方法，父类不实现具体方法，子类去实现，子类调用不需要使用super
extension BaseViewController :UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        
        let count  =  tableView.numberOfRows(inSection: 0) - 1
        
        if (row == count) && !isPullup && needPullUp {
            
            isPullup = true
            loadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          tableview?.deselectRow(at: indexPath, animated: true)
    }
    
    
}
