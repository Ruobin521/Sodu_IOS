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
    
    let vm = ViewModelInstance.Instance.HotAndRecommend
    
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
        
        vm.loadCacheData(vc: self)
        
        vm.loadData { (isSuccess) in
            
            if  isSuccess {
                
                self.tableview?.reloadData()
                self.showToast(content: "已加载热门推荐数据")
            }
            else {
                
                self.showToast(content: "热门推荐数据加载失败",false)
            }
            
            super.endLoadData()
        }
        
        
    }
}






extension HotAndRecommendViewController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return  vm.hotBookList.count
            
        } else {
            
            return vm.recommendBookList.count
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        if indexPath.section == 0 {
            
            cell.book = vm.hotBookList[indexPath.row]
            
            cell.txtBookName?.text = vm.hotBookList[indexPath.row].bookName
            cell.txtUpdateTime?.text = vm.hotBookList[indexPath.row].updateTime
            cell.txtUpdateChpterName?.text = vm.hotBookList[indexPath.row].chapterName
            
        }  else {
            
            
            cell.book = vm.recommendBookList[indexPath.row]
            
            cell.txtBookName?.text = vm.recommendBookList[indexPath.row].bookName
            cell.txtUpdateTime?.text = vm.recommendBookList[indexPath.row].updateTime
            cell.txtUpdateChpterName?.text = vm.recommendBookList[indexPath.row].chapterName
            
        }
        
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        switch section {
    //
    //        case 0:
    //
    //            return  "热门"
    //
    //        case 1:
    //
    //            return  "推荐"
    //
    //        default:
    //
    //            return  ""
    //        }
    //
    //    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
        
        let book = indexPath.section == 0 ? vm.hotBookList[indexPath.row]  : vm.recommendBookList[indexPath.row]
        
        CommonPageViewModel.navigateToUpdateChapterPage(book, navigationController)
    }
    
    
    override  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "添加至书架", handler: { (action, indexPath) in
            
            var book:Book
            
            if indexPath.section == 0 {
                
                book = self.vm.hotBookList[indexPath.row]
                
            } else {
                
                book = self.vm.recommendBookList[indexPath.row]
                
            }
            
            CommonPageViewModel.AddBookToShelf(book: book)
            
        })
        
        action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        return [action1]
        
    }
    
    
}


extension HotAndRecommendViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
         
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
    }
    
}



