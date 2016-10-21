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
    
    lazy var bookList = [Book]()
    
    
    override func InitData() {
        
        let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.BookShelf)
        
        if (tempList.count) > 0 {
            
            bookList.removeAll()
            
            bookList += tempList
            
            tableview?.reloadData()
        }
        
        loadDataByPageIndex()
        
    }
    
    override func pullDownToLoadData() {
        
        refreshControl?.endRefreshing()
        loadDataByPageIndex()
    }
    
    
    
    func loadDataByPageIndex() {
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中", nil)
            
            return
        }
        
        isLoading = true
        
        HttpUtil.instance.AFrequest(url: SoDuUrl.homePage, requestMethod: .GET, postStr: nil,parameters: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess  {
                   
                    ToastView.instance.showToast(content: "个人收藏数据加载失败",nil)
                    
                }  else {
                    
                    self.bookList.removeAll()
                    
                    self.bookList +=  AnalisysHtmlHelper.analisysBookShelfHtml(html as? String)
                    
                    self.tableview?.reloadData()
                    
                    ToastView.instance.showToast(content: "已加载个人收藏数据",nil)
                    
                    BookCacheHelper.SavaBookListAsFile(self.bookList, .BookShelf)
                    
                }
                
                 super.endLoadData()
              
            }
            
        }
        
    }
  
}



extension BookshelfViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension BookshelfViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
