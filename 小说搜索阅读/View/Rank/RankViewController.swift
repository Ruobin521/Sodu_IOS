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
        
        vm.loadCacheData(self)
        
        if pageindex > 0 {
            
            
            setTitleView()
        }
        
        
        
        vm.loadRankListDataByPageIndex(pageindex) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                
                self.showToast(content: "已加载排行榜第\(pageindex+1)页数据")
                
                
            }else {
                
                self.showToast(content: "第\(pageindex+1)页数据加载失败", false)
            }
            
            super.endLoadData()
        }
        
        
    }
}


extension RankViewController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        cell.rankView.isHidden = false
        
        cell.book = vm.bookList[indexPath.row]
        
        cell.txtBookName?.text = vm.bookList[indexPath.row].bookName
        cell.txtUpdateTime?.text = vm.bookList[indexPath.row].updateTime
        cell.txtUpdateChpterName?.text = vm.bookList[indexPath.row].chapterName
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
        
        CommonPageViewModel.navigateToUpdateChapterPage(vm.bookList[indexPath.row], navigationController)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return  userLogon
    }
    
    
    override  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "添加至书架", handler: { (action, indexPath) in
            
            let book = self.vm.bookList[indexPath.row]
            
            CommonPageViewModel.AddBookToShelf(book: book)
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
            
            
            
        })
        
        action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        return [action1]
        
    }
    
    
}


extension RankViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
    }
    
}
