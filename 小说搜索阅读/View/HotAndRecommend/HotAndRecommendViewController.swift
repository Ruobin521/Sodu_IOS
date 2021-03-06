//
//  HotViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit



private let cellId = "cellId"

class HotAndRecommendViewController: BaseViewController {
    
    let vm = ViewModelInstance.instance.hotAndRecommend
    
    override func initData() {
        
        loadData()
        
    }
    
    
    override func loadData() {
        
        if  checkIsLoading() {
            
            return
        }
        
        refreshData()
    }
    
    
    func refreshData() {
        
        isLoading = true
        
        if vm.bookList.count == 0 {
            
            vm.loadCacheData(vc: self)
            
        }
        
        
        
        vm.loadData { (isSuccess) in
            
            if  isSuccess {
                
                self.tableview?.reloadData()
                
            }
            else {
                
                self.showToast(content: "热门推荐数据加载失败",false)
            }
            
            super.endLoadData(isSuccess)
        }
        
        
    }
}






extension HotAndRecommendViewController {
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        let book = vm.bookList[indexPath.section]
        
        cell.txtBookName?.text = book.bookName
        cell.txtUpdateTime?.text = book.updateTime
        cell.txtUpdateChpterName?.text = book.chapterName
        
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return vm.bookList.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
        
        let book =  vm.bookList[indexPath.section]
        
        CommonPageViewModel.navigateToUpdateChapterPage(book, navigationController)
    }
    
    
    override  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "追更", handler: { (action, indexPath) in
            
            var book:Book
            
            book = self.vm.bookList[indexPath.section]
            
            CommonPageViewModel.AddBookToShelf(book: book.clone())
            
            self.tableview?.isEditing = false
            
        })
        
        action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        return [action1]
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return  ViewModelInstance.instance.userLogon
    }
    
    
}


extension HotAndRecommendViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        super.setupSeachItem()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
    }
    
}



