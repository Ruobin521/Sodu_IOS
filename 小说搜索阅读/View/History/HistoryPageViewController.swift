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
    
    override func initData() {
        
        vm.loadHistoryFormDatabase()
        
    }
    
    
    override func   viewWillAppear(_ animated: Bool) {
        
        self.tableview?.reloadData()
        
    }
    
    
    func clearAllHitory() {
        
        
        SoDuSQLiteManager.shared.clearAll(tableName: TableName.History.rawValue) { (isSuccess) in
            
            self.vm.bookList.removeAll()
            
            self.tableview?.reloadData()
            
        }
    }
    
}


extension HistoryPageViewController {
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return vm.bookList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryTableViewCell
        
        let book = vm.bookList[indexPath.section]
        
        cell.txtChapterName?.text = book.lastReadChapterName
        cell.txtBookName?.text = book.bookName
        cell.txtTime?.text = book.updateTime
        
        cell.coverImage.sd_setImage(with:URL(string: book.coverImage ?? "") , placeholderImage: UIImage(named: "cover"))
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let  book  = vm.bookList[indexPath.section]
        
        let bc = BookContentViewController()
        
        bc.vm.currentBook = book.clone()
        
        present(bc, animated: true, completion: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "   删除   ", handler: { (action, indexPath) in
            
            if   indexPath.section > self.vm.bookList.count - 1 {
                
                return
            }
            
            
            let book =  self.vm.bookList[indexPath.section]
            
            self.vm.deleteItem(book:book) { (success) in
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        var array = [IndexPath]()
                        
                        array.append(indexPath)
                        
                        self.vm.bookList.remove(at: indexPath.section)
                        
                        tableView.deleteSections([indexPath.section], with:  UITableViewRowAnimation.automatic)
                        
                        tableView.reloadData()
                        
                    }else {
                        
                        self.showToast(content: "\(book.bookName)历史记录删除失败",false)
                    }
                    
                    
                }
            }
            
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
        })
        
        //FF2133
        action1.backgroundColor =  #colorLiteral(red: 1, green: 0.1294117647, blue: 0.2, alpha: 1)
        
        // action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 1)
        
        return [action1]
    }
    
    
}


extension  HistoryPageViewController {
    
    override func setupUI() {
        
        setUpNavigationBar()
        
        setupTableview()
        
        setBackColor()
        
        setRightNavButton()
        
        let cellNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
    }
    
    
    func setRightNavButton() {
        
        
        
        // self.navItem.rightBarButtonItem = UIBarButtonItem(title: "清空" , style: .plain, target: self, action: #selector(clearAllHitory))
        self.navItem.rightBarButtonItem = UIBarButtonItem(title: "清空历史", fontSize: 16, target: self, action: #selector(clearAllHitory), isBack: false)
        
        
    }
}
