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
    
    
    override func initData() {
        
        vm.loadCacheData(self)
        
        loadData()
    }
    
    
    override func loadData() {
        
        if  checkIsLoading() {
            
            return
        }
        
        loadDataByPageIndex()
    }
    
    
    func loadDataByPageIndex() {
        
        isLoading = true
        
        vm.loadBookShelfPageData {(isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        cell.book = vm.bookList[indexPath.row]
        
        cell.txtBookName?.text = vm.bookList[indexPath.row].bookName
        cell.txtUpdateTime?.text = vm.bookList[indexPath.row].updateTime
        cell.txtUpdateChpterName?.text = vm.bookList[indexPath.row].chapterName
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        CommonPageViewModel.navigateToUpdateChapterPage(vm.bookList[indexPath.row], navigationController)
    }
    
    
}


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        
        
    }
    
}
