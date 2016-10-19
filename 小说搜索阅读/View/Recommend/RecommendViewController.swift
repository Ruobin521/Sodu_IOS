//
//  RecommendViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit



private let cellId = "cellId"

class RecommendViewController: BaseViewController {
    
    lazy var bookList = [Book]()
    
    let pageCount = 8
    
    var pageIndex = 0
    
    
    override func InitData() {
        
        if  isLoading  {
            
            return
        }
        
        pageIndex = 0
        loadDataByPageIndex(0)
        
    }
    
    
    
    
    override func pullDownToLoadData() {
        
        refreshControl?.endRefreshing()
        
        InitData()
    }
    
 
    
    func loadDataByPageIndex(_ pageindex: Int) {
        
        isLoading = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        ToastView.instance.showLoadingView()
        
        HttpUtil.instance.request(url: SoDuUrl.homePage, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            if !isSuccess {
                
                ToastView.instance.showToast(content: "推荐数据加载失败",nil)
                
                return
            }
            
            
            if pageindex == 0 {
                
                self.bookList.removeAll()
                
            }
            
            
            DispatchQueue.main.async {
                
                self.bookList +=  AnalisysHtmlHelper.analisysRecommendHtml(html)
                
                self.tableview?.reloadData()
                
                super.endLoadData()
                
                ToastView.instance.showToast(content: "已加载推荐阅读数据",nil)
                
            }
        }
        
    }
    
    
}




extension RecommendViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension RecommendViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
