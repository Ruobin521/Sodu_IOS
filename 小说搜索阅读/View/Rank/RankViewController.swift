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
    
    
    var vm =  ViewModelInstance.Instance.rank
    
    override func initData() {
        
        vm.loadCacheData(self)
        
        loadData()
    }
    
    override func loadData() {
        
        needPullUp = true
        
        refreshControl?.endRefreshing()
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中")
            return
            
        }
        
        
        if isPullup {
            
            loadDataByPageIndex(vm.pageIndex + 1)
            
        }  else {
            
            loadDataByPageIndex(0)
        }
        
    }
    
    
    func loadDataByPageIndex(_ pageindex: Int) {
        
        if  pageindex == vm.pageCount {
            
            isPullup = false
            ToastView.instance.showToast(content: "已加载到最后一页")
            return
        }
        
        isLoading = true
        
        vm.loadRankListDataByPageIndex(pageindex) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                ToastView.instance.showToast(content: "已加载排行榜第\(pageindex+1)页数据")
                
                self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                
            } else {
                
                ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败", false)
                
                print("第\(pageindex+1)页数据加载失败")
            }
            
            super.endLoadData()
        }
        
        
    }
}


extension RankViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = vm.bookList[indexPath.row].bookName
        
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
