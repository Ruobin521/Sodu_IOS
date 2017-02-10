
//
//  LocalBookPageViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit
import SDWebImage


private let cellId = "cellId"

class LocalBookPageViewController: BaseViewController {
    
    let vm = ViewModelInstance.instance.localBook
    
    override func initData() {
        
        loadData()
    }
    
    override func loadData() {
        
        self.emptyLayer?.isHidden = true
        
        if vm.isChecking {
            
            self.endLoadData(false)
            
            return
        }
        
        loadLocalBook()
    }
    
    
    func loadLocalBook(){
        
        vm.isChecking = true
        
        isLoading = true
        
        self.emptyLayer?.isHidden = true
        
        DispatchQueue.main.async {
            
            self.setTitleView("更新中...")
            
        }
        
        
        
        vm.loadLoaclBooks(completion: { (isSuccess) in
            
            DispatchQueue.main.async {
                
                if self.vm.bookList.count == 0 {
                    
                    self.emptyLayer?.isHidden = false
                    
                } else{
                    
                    self.emptyLayer?.isHidden = true
                    
                    self.tableview?.reloadData()
                    
                }
                
                self.endLoadData(true)
                
            }
            
        }) {
            
            DispatchQueue.main.async {
                
                self.navItem.titleView = nil
                self.vm.isChecking  = false
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableview?.reloadData()
        
        if !ViewModelInstance.instance.setting.isLocalBookAutoDownload {
            
            self.navItem.rightBarButtonItem = UIBarButtonItem(title: "全部更新", fontSize: 16, target: self, action: #selector(updateAll), isBack: false)
            
        } else {
            
            self.navItem.rightBarButtonItem = nil
            
        }
        
        if self.vm.bookList.count == 0 {
            
            self.emptyLayer?.isHidden = false
            
        } else{
            
            self.emptyLayer?.isHidden = true
            
            
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
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LocalBookTableViewCell
        
        let tempVm = vm.bookList[indexPath.section]
        
        tempVm.setContentBlock = nil
        
        cell.vm =  vm.bookList[indexPath.section]
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let book = vm.bookList[indexPath.section].book
        
        let bc = BookContentViewController()
        
        bc.vm.currentBook = book?.clone()
        
        if book?.isNew == "1" {
            
            book?.isNew = "0"
            
            self.vm.updateBookDB(book: book!, completion: { (isSuccess) in
                
                self.tableview?.reloadData()
            })
        }
        
        present(bc, animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let bookVm =   self.vm.bookList[indexPath.section]
        
        let action1  =  UITableViewRowAction(style: .normal, title: "  删除  ", handler: { (action, indexPath) in
            
            if   indexPath.section > self.vm.bookList.count - 1 {
                
                return
            }
            
            if self.vm.isChecking {
                
                self.showToast(content: "正在检测更新，请稍后", true, true)
                
                return
            }
            
            self.vm.removeBookFromList(bookVm.book.bookId!) { (isSuccess) in
                
                DispatchQueue.main.async {
                    
                    if isSuccess {
                        
                        var array = [IndexPath]()
                        
                        array.append(indexPath)
                        
                        self.vm.bookList.remove(at: indexPath.section)
                        
                        bookVm.isDeleted = true
                        
                        tableView.deleteSections([indexPath.section], with:  UITableViewRowAnimation.automatic)
                        
                        if self.vm.bookList.count == 0 {
                            
                            self.emptyLayer?.isHidden = false
                        }
                        
                    }else {
                        
                        self.showToast(content: "\((bookVm.book.bookName)!)删除失败",false)
                    }
                    
                }
            }
            
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
        })
        
        action1.backgroundColor =  #colorLiteral(red: 1, green: 0.1294117647, blue: 0.2, alpha: 1)
        
        
        let action2  =  UITableViewRowAction(style: .normal, title: "  更新  ", handler: { (action, indexPath) in
            
            if   indexPath.section > self.vm.bookList.count - 1 {
                
                return
            }
            
            let bookVm =   self.vm.bookList[indexPath.section]
            
            bookVm.downLoadUpdate(completion: nil)
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
        })
        
        action2.backgroundColor =  #colorLiteral(red: 0.7843137255, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        
        
        let action3  =  UITableViewRowAction(style: .normal, title: "  缓存  ", handler: { (action, indexPath) in
            
            if   indexPath.section > self.vm.bookList.count - 1 {
                
                return
            }
            
            
            if self.vm.isChecking {
                
                self.showToast(content: "正在检测更新，请稍后", true, true)
                
                return
            }
            
            let bookVm =   self.vm.bookList[indexPath.section]
            
            bookVm.checkMethod(completion: {
                
                bookVm.downLoadUpdate(completion: nil)
                
            })
            
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
        })
        
        
        action3.backgroundColor =  #colorLiteral(red: 0.7843137255, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        
        if bookVm.book.isLocal == "1" {
            
            return [action1,action2]
            
        }  else{
            
            return [action1,action3]
        }
        
        
    }
    
}

extension  LocalBookPageViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        let cellNib = UINib(nibName: "LocalBookTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
        setEmptyBackView("　　1.点击阅读正文菜单中的”缓存“按钮即可缓存全部章节内容。\n　　2.您可在“设置-下载中心”中查看下载进度。\n　　3.点击阅读正文页面右下方红色按钮，将添加该小说到本地书架。\n　　4.下载完成或添加完毕后即可在此处点击阅读\n")
        
   
        
        // self.navItem.rightBarButtonItem = UIBarButtonItem(title: "全部更新", fontSize: 16, target: self, action: #selector(updateAll), isBack: false)//       self.navItem.leftBarButtonItem = UIBarButtonItem(title: "更新本地", fontSize: 16, target: self, action: #selector(updateLocal), isBack: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initData), name: NSNotification.Name(rawValue: DownloadCompletedNotification), object: nil)
        
    }
    
    
    func updateAll() {
        
        if self.vm.isChecking {
            
            return
        }
        
        for item in  vm.bookList {
            
            if item.book.isLocal != "1" {
                
                continue
            }
            
            item.downLoadUpdate(completion: nil)
            
        }
        
    }
    
    
    func updateLocal() {
        
        for item in  vm.bookList {
            
            if item.book.isLocal != "1" {
                
                continue
            }
            
            item.downLoadUpdate(completion: nil)
            
        }
        
    }
    
}


