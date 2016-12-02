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
        
        vm.loadCacheData(self)
        
        loadData()
    }
    
    
    override func loadData() {
        
        if  checkIsLoading() {
            
            return
        }
        
        isLoading = true
        
        
        vm.loadBookShelfPageData {(isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                self.showToast(content: "已加载个人书架数据")
                
                if self.vm.bookList.count ==  0 {
                    
                    self.setEmptyBackView()
                    
                }
            } else {
                
                self.showToast(content: "个人书架加载失败",false)
            }
            
            super.endLoadData()
            
        }
        
    }
    
    
    func addBookToShelf(_ notification:Notification) {
        
        guard  let book = notification.object as? Book  else{
            
            return
        }
        
        DispatchQueue.main.async {
            
            self.vm.bookList.insert(book, at: 0)
            self.removeEmptyView()
            self.tableview?.reloadData()
            
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}




extension BookshelfViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 105
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
        }
        
        
        CommonPageViewModel.navigateToUpdateChapterPage(book, navigationController)
        
        
        vm.updateBook(book: book) { (isSuccess) in
            
            self.tableview?.reloadRows(at: [indexPath], with: .automatic)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "   删除   ", handler: { (action, indexPath) in
            
            if self.isDeleting {
                
                ToastView.instance.showGlobalToast(content: "正在执行删除操作，请稍后")
                
            }else {
                
                if   indexPath.section > self.vm.bookList.count - 1 {
                    
                    return
                }
                
                self.isDeleting = true
                
                let book =   self.vm.bookList[indexPath.section]
                
                self.vm.removeBookFromList(book) { (success) in
                    
                    DispatchQueue.main.async {
                        
                        if success {
                            
                            var array = [IndexPath]()
                            
                            array.append(indexPath)
                            
                            self.vm.bookList.remove(at: indexPath.section)
                            
                            tableView.deleteSections([indexPath.section], with:  UITableViewRowAnimation.automatic)
                            
                            // tableView.reloadData()
                            
                            self.showToast(content: "\(book.bookName!)取消收藏成功")
                            
                        }else {
                            
                            self.showToast(content: "\(book.bookName)取消收藏失败",false)
                        }
                        
                        self.isDeleting = false
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


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        super.setupSeachItem()
        
        let cellNib = UINib(nibName: "BookshelfTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
    }
    
    
    func setEmptyBackView() {
        
        emptyView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        emptyView?.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.text = "您的书架空空如也，在排行榜或热门推荐中向左滑动添加几本吧..."
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor =  UIColor.lightGray
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0 , width:  300 , height: 100)
        label.center =  CGPoint(x: view.center.x, y: view.center.y - 80)
        label.textAlignment = .center
        
        emptyView?.addSubview(label)
        view.insertSubview(emptyView!, belowSubview: navigationBar)
        
    }
    
    
    func removeEmptyView() {
        
        emptyView?.removeFromSuperview()
        
    }
}
