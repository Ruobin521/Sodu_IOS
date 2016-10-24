//
//  RankViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class RankViewController: BaseViewController {
    
    
    var viewModel =  ViewModelInstance.Instance.rank
    
    
    override func loadData() {
        
        needPullUp = true
        
        refreshControl?.endRefreshing()
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中",nil)
            return
            
        }
        
        viewModel.loadCacheData(vc: self)
        
        if isPullup {
            
            loadDataByPageIndex(viewModel.pageIndex + 1)
            
        }  else {
            
            loadDataByPageIndex(0)
        }
        
    }
    
    
    func loadDataByPageIndex(_ pageindex: Int) {
        
        if  pageindex == viewModel.pageCount {
            
            isPullup = false
            ToastView.instance.showToast(content: "已加载到最后一页",nil)
            return
        }
        
        isLoading = true
        
        viewModel.loadRankListDataByPageIndex(pageindex) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                ToastView.instance.showToast(content: "已加载排行榜第\(pageindex+1)页数据",nil)
                
                self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                
            } else {
                
                ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败",nil)
                
                print("第\(pageindex+1)页数据加载失败")
            }
            
            super.endLoadData()
        }
        
        
    }
}


extension RankViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = viewModel.bookList[indexPath.row].bookName
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
}


extension RankViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
