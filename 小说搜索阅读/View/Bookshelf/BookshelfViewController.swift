//
//  BookshelfViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

//class BookshelfViewController: BaseViewController {


private let cellId = "cellId"



class BookshelfViewController: BaseViewController {
    
    
    let vm = ViewModelInstance.Instance.bookShelf
    
    
    override func loadData() {
        
        refreshControl?.endRefreshing()
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中")
            
            return
        }
        
        vm.loadCacheData(self)
        
        loadDataByPageIndex()
        
    }
    
    
    func loadDataByPageIndex() {
        
        isLoading = true
        
        vm.loadBookShelfPageData {(isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                ToastView.instance.showToast(content: "已加载个人收藏数据")
                
            } else {
                
                ToastView.instance.showToast(content: "个人收藏数据加载失败",false)
                
            }
            
            super.endLoadData()
            
        }
        
    }
    
}



extension BookshelfViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = vm.bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
