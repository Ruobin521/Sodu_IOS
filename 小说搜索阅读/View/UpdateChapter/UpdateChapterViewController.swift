//
//  UpdateChapterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class UpdateChapterViewController: BaseViewController {

    
    
    var vm =  ViewModelInstance.Instance.rank
    
    override func initData() {
        
        vm.loadCacheData(self)
        
        loadData()
    }
    
    override func loadData() {
        
        needPullUp = true
        
        if  checkIsLoading() {
            
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
            return
            
        }
        
        isLoading = true
        
        vm.loadRankListDataByPageIndex(pageindex) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                
            }
            
            super.endLoadData()
        }
        
        
    }
}


extension UpdateChapterViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        cell.book = vm.bookList[indexPath.row]
        
        cell.txtBookName?.text = vm.bookList[indexPath.row].bookName
        cell.txtUpdateTime?.text = vm.bookList[indexPath.row].updateTime
        cell.txtUpdateChpterName?.text = vm.bookList[indexPath.row].chapterName
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
}


extension UpdateChapterViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
    }
    
}
