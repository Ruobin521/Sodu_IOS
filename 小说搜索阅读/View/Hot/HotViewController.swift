//
//  HotViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit



private let cellId = "cellId"

class HotViewController: BaseViewController {
    
    lazy var bookList = [Book]()
    
    let pageCount = 8
    
    var pageIndex = 0
    
    
    override func InitData() {
        
        let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.Hot)
        
        if (tempList.count) > 0 {
            
            bookList.removeAll()
            
            bookList += tempList
            
            tableview?.reloadData()
        }
        
        loadDataByPageIndex()
        
    }
    
    
    
    
    override func pullDownToLoadData() {
        
        refreshControl?.endRefreshing()
        
        loadDataByPageIndex()
    }
    
    
    
    func loadDataByPageIndex() {
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中",nil)
            
            return
        }
        
        
        isLoading = true
        
        HttpUtil.instance.request(url: SoDuUrl.homePage, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                if  !isSuccess {
                    
                    ToastView.instance.showToast(content: "热门小说数据加载失败",nil)
                    
                } else {
                    
                    self.bookList.removeAll()
                    
                    self.bookList +=  AnalisysHtmlHelper.analisysHotHtml(html)
                    
                    self.tableview?.reloadData()
                    
                    ToastView.instance.showToast(content: "已加载热门小说数据",nil)
                    
                    BookCacheHelper.SavaBookListAsFile(self.bookList, .Hot)
                    
                }
                
                super.endLoadData()
            }
        }
        
    }
    
}



extension HotViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension HotViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}



