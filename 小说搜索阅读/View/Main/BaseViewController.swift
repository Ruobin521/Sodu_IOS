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
    
    var isPullup = false
    
    var isPullDown = false
    
    var tableview:UITableView?
    
    var refreshControl:UIRefreshControl?
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    
    lazy var navItem = UINavigationItem()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //取消自动缩进
        automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
        
        InitData()
        
    }
    
    
    override var title: String? {
        
        didSet {
            navItem.title = title
        }
        
    }
    
    
    /// 初始化数据
    func InitData()  {
        
        endLoadData()
    }
    
    
    /// （下拉刷新）
    func pullDownToLoadData()  {
        
        endLoadData()
    }
    
    
    ///（上拉加载）
    func pullUpToloadData() -> () {
        
        endLoadData()
        
    }
    
    ///滚到顶部
    func goToTop() {
        
        let offset =  ((tableview?.contentOffset)?.y) ??  -50.0
        
        if  offset  <=  CGFloat(-50.0)    {
            
            InitData()
        }
        
        if   (tableview?.numberOfRows(inSection: 0))! > 0 {
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            tableview?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        
    }
    
    
    func endLoadData() {
        
        refreshControl?.endRefreshing()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        isLoading = false
        
        isPullup = false
        
        isPullDown = false
        
    }
    
    

    
}

extension BaseViewController {
    
    func setupUI() -> () {
        
        setBackColor()
        setUpNavigationBar()
        setuoTableview()
        
    }
    
    
    func setuoTableview() -> () {
        
        tableview = UITableView(frame:  view.bounds, style: .plain)
        
        view.insertSubview(tableview!, belowSubview: navigationBar)
        
        tableview?.dataSource = self
        tableview?.delegate = self
        
        
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.tintColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)

        
        refreshControl?.addTarget(self, action: #selector(pullDownToLoadData), for: .valueChanged)
        
        tableview?.addSubview(refreshControl!)
        
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        
        let count  =  tableView.numberOfRows(inSection: 0) - 1
        
        if (row == count) && !isPullup {
            
            pullUpToloadData()
        }
        
    }
    
}
