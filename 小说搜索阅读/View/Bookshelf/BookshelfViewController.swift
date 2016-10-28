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
         
        print(isLoading)
        loadDataByPageIndex()
    }
    
    
    func loadDataByPageIndex() {
        
        isLoading = true
        
        vm.loadBookShelfPageData {(isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                self.showToast(content: "已加载个人书架数据")
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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "   删除   ", handler: { (action, indexPath) in
            
            DispatchQueue.main.async {
                
                let book = self.vm.bookList[indexPath.row]
                
                self.vm.removeBookFromList(book,indexPath: indexPath) { (success) in
                    
                    if success {
                        
                        var array = [IndexPath]()
                        
                        array.append(indexPath)
                        
                        tableView.deleteRows(at: array, with: .automatic)
                        
                        tableView.isEditing = false
                        
                        self.showToast(content: "\(book.bookName!)取消收藏成功")
                        
                    }else {
                        
                        self.showToast(content: "\(book.bookName)取消收藏失败",false)
                    }
                    
                    
                    
                }
                
                
            }
            
        })
        
        //FF2133
        action1.backgroundColor =  #colorLiteral(red: 1, green: 0.1294117647, blue: 0.2, alpha: 1)
        
        // action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 1)
        
        return [action1]
    }
    
}


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        
        
    }
    
}
