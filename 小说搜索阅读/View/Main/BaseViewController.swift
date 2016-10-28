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
            
            showToast(content: "数据加载正在努力加载中")
            
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
        
        tableview = UITableView(frame:  view.bounds, style: .plain)
        
        tableview?.dataSource = self
        tableview?.delegate = self
        
        tableview?.backgroundColor = UIColor.white
        
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tableview?.scrollIndicatorInsets = tableview!.contentInset
        
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.tintColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableview?.addSubview(refreshControl!)
        
        
        tableview?.sectionFooterHeight = 5
        
        tableview?.tableHeaderView = UIView(frame: CGRect(x: CGFloat( 0.0), y: CGFloat( 0.0), width:CGFloat( 0.0), height: CGFloat.leastNormalMagnitude))
        
        tableview?.rowHeight = 68
        
        //  self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        tableview?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        view.insertSubview(tableview!, belowSubview: navigationBar)
        
    }
    
    
    func setUpNavigationBar()   {
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        
        navigationBar.barTintColor = self.view.tintColor
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationBar.tintColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_discover"), style: .plain, target: self, action: #selector(goToSearchPage))
        
        
    }
    
    
    
    func  setBackColor()  {
        
        view.backgroundColor = UIColor.white
    }
    
    
    func goToSearchPage() {
        
        print("点击了搜索按钮")
        
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
    
    
    
    /// 主要是上拉加载
    ///
    /// - parameter tableView: <#tableView description#>
    /// - parameter cell:      <#cell description#>
    /// - parameter indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        
        let section = (tableview?.numberOfSections)! - 1
        
        let count  =  tableView.numberOfRows(inSection: section) - 1
        
        if (row == count) && !isPullup && needPullUp && !isLoading {
            
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
    
    
    
    
    /// 设置section的header的高度
    ///
    /// - parameter tableView: <#tableView description#>
    /// - parameter section:   <#section description#>
    ///
    /// - returns: <#return value description#>
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
    
    ///选中后取消选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "添加书架", handler: { (action, indexPath) in
            
            DispatchQueue.main.async {
                
                self.showToast(content: "添加收藏成功")
            }
            
        })
        
        //FF2133
        //action1.backgroundColor =  #colorLiteral(red: 1, green: 0.1294117647, blue: 0.2, alpha: 1)
        
        action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
    
        
        return [action1]
    }
    
    
    
}





extension UIViewController {
    
    
    func showToast(content:String,_ isScuccess:Bool = true) {
        
        
        self.view.addSubview(ToastView.instance.showToast(content: content,isScuccess))
        
    }
}
