//
//  DownCenterViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let commonCellId = "cellId"

class DownCenterViewController: BaseViewController {
    
    let vm = ViewModelInstance.instance.downloadCenter
    
    
    func removeDownloadItem(obj:Notification) {
        
        DispatchQueue.main.async {
            
            self.tableview?.reloadData()
        }
        
    } 
     
}


extension DownCenterViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: commonCellId, for: indexPath) as! DownloadTableViewCell
        
        let viewModel = vm.bookList[indexPath.section]
        
        cell.vm = viewModel
                 
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
    }
    
    
}


extension DownCenterViewController {
    
    
    override func setupUI() {
        
        setBackColor()
        setUpNavigationBar()
        setupTableview()
        
        let cellNib1 = UINib(nibName: "DownloadTableViewCell", bundle: nil)
        tableview?.register(cellNib1, forCellReuseIdentifier: commonCellId)
        
         NotificationCenter.default.addObserver(self, selector: #selector(removeDownloadItem), name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: nil)
    }
    
    
}
