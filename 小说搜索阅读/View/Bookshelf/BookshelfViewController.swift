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
    
  
    
    let vm = ViewModelInstance.instance.bookShelf
    
    var isDeleting:Bool = false
    
    override func initData() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(addBookToShelf), name: NSNotification.Name(rawValue: AddToBookshelfSuccessNotification), object: nil)
        
        loadData()
    }
    
    
    override func loadData() {
        
        if  checkIsLoading() {
            
            return
        }
        
        isLoading = true
        emptyLayer?.isHidden = true
        failedLayer?.isHidden = true
        
        if vm.bookList.count == 0 {
            
            vm.loadCacheData(self)
            
        }
        
        vm.loadBookShelfPageData {(isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                if self.vm.bookList.count ==  0 {
                    
                    self.emptyLayer?.isHidden = false
                }
                
            }
                else {
//                
//                //  self.failedLayer?.isHidden = false
//                self.showToast(content: "在线收藏加载失败",false)
           }
            
            super.endLoadData(isSuccess)
            
        }
        
    }
    
    
    func addBookToShelf(_ notification:Notification) {
        
        guard  let book = notification.object as? Book  else{
            
            return
        }
        
        DispatchQueue.main.async {
            
            self.vm.bookList.insert(book, at: 0)
            self.emptyLayer?.isHidden = true
            self.tableview?.reloadData()
            
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.vm.needRefresh {
            
            self.tableview?.reloadData()
            
            self.vm.needRefresh = false
        }
        
    }
}




extension BookshelfViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  1
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
            
            vm.updateBook(book: book) { (isSuccess) in
                
                DispatchQueue.main.async {
                    
                    self.tableview?.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
        
        
        CommonPageViewModel.navigateToUpdateChapterPage(book, navigationController)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let book =   self.vm.bookList[indexPath.section]
        
        var actions:[UITableViewRowAction] = [UITableViewRowAction]()
        
        let action1  =  UITableViewRowAction(style: .normal, title: "不追了", handler: { (action, indexPath) in
            
            self.vm.removeBookFromList(book) { (success) in
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        var array = [IndexPath]()
                        
                        array.append(indexPath)
                        
                        if self.vm.bookList.count >= indexPath.section + 1 {
                            
                            self.vm.bookList.remove(at: indexPath.section)
                            
                            tableView.deleteSections([indexPath.section], with:  UITableViewRowAnimation.automatic)
                            
                            // tableView.reloadData()
                            
                            self.showToast(content: "\(book.bookName!)取消收藏成功")

                        }
                        
                        
                        if self.vm.bookList.count == 0 {
                            
                            self.emptyLayer?.isHidden = false
                        }
                        
                    }else {
                        
                        self.showToast(content: "\(book.bookName)取消收藏失败",false)
                    }
                    
                    self.isDeleting = false
                }
            }
            
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
        })
        
        action1.backgroundColor =  #colorLiteral(red: 1, green: 0.1294117647, blue: 0.2, alpha: 1)
        
        actions.append(action1)
        
        if book.isNew == "1"   {
            
            let action2 =  UITableViewRowAction(style: .normal, title: "  标为已读  ", handler: { (action, indexPath) in
                
                self.vm.setHadReaded(book: book, completion: { (isSuccess) in
                    
                    if isSuccess {
                        
                        DispatchQueue.main.async {
                            
                            tableView.isEditing = false
                            
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                            
                        }
                    }
                    
                    })
            })
            
            action2.backgroundColor =  #colorLiteral(red: 0.7843137255, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
            
            actions.append(action2)
        }
        return actions
    }
    
}


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        super.setupSeachItem()
        
        super.setupFailedView()
        
        setEmptyBackView("　　您的书架空空如也，在排行榜或热门推荐中向左滑动添加几本吧...\n\n使用提示：\n　　1.在线书架主要是为了追更，如果想连续阅读，请使用本地书架功能。\n　　2.向左滑动可以对当前项目进行操作。\n　　3.在排行榜或热门推荐页面向左滑动即可添加所选项至个人书架。")
        
        let cellNib = UINib(nibName: "BookshelfTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "全标已读", fontSize: 16, target: self, action: #selector(setAllHasReaded), isBack: false)

        
    }
    
    
    func setAllHasReaded() {
        
        if vm.bookList.count == 0 {
            
            return
        }
        
        for item in vm.bookList {
            
            if item.isNew == "1" {
                
                vm.setHadReaded(book: item, completion: nil)
                
            }
            
        }
        
        self.tableview?.reloadData()
        
    }
    
}
