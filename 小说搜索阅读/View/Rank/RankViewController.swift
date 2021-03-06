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
    
    
    var vm =  ViewModelInstance.instance.rank
    
    
    
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
        
       
        
        if  pageindex == vm.pageCount {
            
            isPullup = false
            return
            
        }
        
        isLoading = true
        
        
        if vm.bookList.count == 0 {
            
            vm.loadCacheData(self)
            
        }
        
        
        
        if pageindex > 0 {
            
            setTitleView()
        }
        
        
        
        vm.loadRankListDataByPageIndex(pageindex) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                  
            }else {
                
                self.showToast(content: "第\(pageindex+1)页数据加载失败", false)
            }
            
            super.endLoadData(isSuccess)
            self.navItem.titleView = nil
            
        }
        
        
    }
}


extension RankViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count
    }
    
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        cell.rankView.isHidden = false
        
      let book = vm.bookList[indexPath.section]
        
        if book.rankChangeValue != nil {
            
            if (book.rankChangeValue!.contains("-")) {
                
                cell.imgRank.image  =  UIImage(named: "down")
                cell.txtRank.text = book.rankChangeValue!.replacingOccurrences(of: "-", with: "")
            } else {
                
                cell.imgRank.image  =  UIImage(named: "up")
                cell.txtRank.text = book.rankChangeValue!
            }
            
        } else {
            
            cell.txtRank.text =  "-"
        }
        
        
        cell.txtBookName?.text = book.bookName
        cell.txtUpdateTime?.text = book.updateTime
        cell.txtUpdateChpterName?.text = book.chapterName
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
        
        CommonPageViewModel.navigateToUpdateChapterPage(vm.bookList[indexPath.section], navigationController)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return  ViewModelInstance.instance.userLogon
    }
    
    
    override  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "追更", handler: { (action, indexPath) in
            
            let book = self.vm.bookList[indexPath.section]
            
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
        super.setupSeachItem()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
      //  setEmptyBackView("使用提示：向左滑动可添加至个人书架")

        
    }
    
}
