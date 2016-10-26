//
//  HotViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit



private let cellId = "cellId"

class HotAndRecommednViewController: BaseViewController {
    
    let vm = ViewModelInstance.Instance.HotAndRecommend
    
    override func initData() {
        
        vm.loadCacheData(vc: self)
        
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
        
        vm.loadData { (isSuccess) in
            
            if  isSuccess {
                
                self.tableview?.reloadData()
            }
            
            super.endLoadData()
        }
        
        
    }
}






extension HotAndRecommednViewController {
    
    
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
    
    
}


extension HotAndRecommednViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
    }
    
}



