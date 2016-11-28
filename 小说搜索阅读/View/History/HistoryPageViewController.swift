//
//  HistoryPageViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/28.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class HistoryPageViewController: BaseViewController {
    
    let cellId = "cellId"
    
    let vm = ViewModelInstance.instance.history
    
    
}


extension HistoryPageViewController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return vm.booklist.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryTableViewCell
        
        
        cell.txtChapterName?.text = vm.booklist[indexPath.section].chapterName
        cell.txtBookName?.text = vm.booklist[indexPath.section].bookName
        cell.txtTime?.text = vm.booklist[indexPath.section].updateTime
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let  book  = vm.booklist[indexPath.section]
        
        print(book)
        
               
    }
    
}


extension  HistoryPageViewController {
    
    override func setupUI() {
        
        setUpNavigationBar()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        
        
        
        let cellNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
        
        
    }
}
