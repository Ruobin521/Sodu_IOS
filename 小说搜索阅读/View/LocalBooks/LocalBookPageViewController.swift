//
//  LocalBookPageViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class LocalBookPageViewController: BaseViewController {
    
    let vm = ViewModelInstance.instance.localBook
    
    override func initData() {
        
        
        vm.loadLoaclBooks { (isSuccess) in
            
            DispatchQueue.main.async {
                
                self.tableview?.reloadData()
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
             self.tableview?.reloadData()
        }
        
    }
    
    
}


extension LocalBookPageViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 95
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookshelfTableViewCell
        
        let book = vm.bookList[indexPath.section]
        
        cell.txtBookName?.text = book.bookName
        
        cell.txtUpdateTime?.text = book.updateTime
        
        cell.txtUpdateChpterName?.text = book.chapterName
        
        cell.txtLastReadChapterName.text = book.lastReadChapterName
        
        if book.isNew == "0" {
            
            cell.imageNew.isHidden = true
            
        } else {
            
            cell.imageNew.isHidden = false
            
        }
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let book = vm.bookList[indexPath.section]
        
        if book.isNew == "1" {
            
            book.lastReadChapterName = book.chapterName
            book.isNew = "0"
            
            vm.updateBookDB(book: book) { (isSuccess) in
                
                self.tableview?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        
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
            
            let book =   self.vm.bookList[indexPath.section]
            
            self.vm.removeBookFromList(book) { (success) in
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        var array = [IndexPath]()
                        
                        array.append(indexPath)
                        
                        self.vm.bookList.remove(at: indexPath.section)
                        
                        tableView.deleteSections([indexPath.section], with:  UITableViewRowAnimation.automatic)
                        
                    }else {
                        
                        self.showToast(content: "\((book.bookName)!)删除失败",false)
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

extension  LocalBookPageViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "BookshelfTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(initData), name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: nil)
        
    }
    
}


