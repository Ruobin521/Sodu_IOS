//
//  UpdateChapterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "updateCellid"

class UpdateChapterViewController: BaseViewController {
    
    var vm =  UpdateChapterViewModel()
    
    override func initData() {
        
        needPullUp = true
        
        loadData()
    }
    
    override func loadData() {
        
        
        
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
        
        if  pageindex == vm.pageCount  && pageindex != 0 {
            
            isPullup = false
            ToastView.instance.showToast(content: "已加载到最后一页")
            
            return
            
        }
        
        isLoading = true
        
        vm.loadUpdateChapterListDataByPageIndex(pageindex) { [weak self]  (isSuccess) in
            
            if isSuccess {
                
                self?.tableview?.reloadData()
                self?.navigationItem.title = "\(self?.vm.currentBook?.bookName) - \(pageindex+1) / \(self?.vm.pageCount)"
                
            }
            
            self?.endLoadData()
        }
    }
}

extension UpdateChapterViewController {
    
    
    func chapterDidSelected(_ book:Book) {
       
        
        let bc = BookContentViewController()
        let vc = UINavigationController(rootViewController: bc)
        
        bc.currentBook = book
         
        present(vc, animated: true, completion: nil)
       
    }
    
}


extension UpdateChapterViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.chapterList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UpdateChapterTableViewCell
        
        
        cell.txtChapterName?.text = vm.chapterList[indexPath.row].chapterName
        cell.txtUpdateTime?.text = vm.chapterList[indexPath.row].updateTime
        cell.txtLywzName?.text = vm.chapterList[indexPath.row].lywzName
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let  book  = vm.chapterList[indexPath.row]
        
        chapterDidSelected(book)
        
    }
    
}


extension UpdateChapterViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "UpdateChapterTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
    }
    
}
