//
//  RankViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class RankViewController: BaseViewController {
    
    lazy var bookList = [Book]()
    
    let pageCount = 8
    
    var pageIndex = 0
    
    
    override func InitData() {
        
        let tempList =  BookCacheHelper.ReadBookListCacheFromFile(ListType.Rank)
        
        if (tempList.count) > 0 {
            
            bookList.removeAll()
            
            bookList += tempList
            
            tableview?.reloadData()
        }
        
        loadDataByPageIndex(0)
        
    }
    
    
    override func pullDownToLoadData() {
        
     refreshControl?.endRefreshing()
        
        loadDataByPageIndex(0)
    }
    
    
    override func pullUpToloadData() {
        
        if  pageIndex == pageCount - 1 {
            
            return
        }
        
        isPullup = true
        
        loadDataByPageIndex(pageIndex + 1)
        
    }
    
    func loadDataByPageIndex(_ pageindex: Int) {
        
        if  isLoading  {
            
            ToastView.instance.showToast(content: "数据加载正在努力加载中",nil)
            
            return
        }
        
        isLoading = true
        
        let urlStr =  SoDuUrl.rankPage.replacingOccurrences(of: "_", with: "_\(pageindex + 1)")
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil)  { (html,isSuccess) in
            
            DispatchQueue.main.async {
                
                if !isSuccess {
                    
                    ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败",nil)
                    
                    print("第\(pageindex+1)页数据加载失败")
                    
                }  else {
                    
                    if pageindex == 0 {
                        
                        self.bookList.removeAll()
                    }
                    
                    
                    self.pageIndex = pageindex
                    
                    self.bookList += AnalisysHtmlHelper.analisysRankHtml(html)
                    
                    self.tableview?.reloadData()
                  
                    ToastView.instance.showToast(content: "已加载排行榜第\(pageindex+1)页数据",nil)
                    
                    self.navItem.title = "排行榜 - \(pageindex+1) / 8"
                    
                    if pageindex == 0 {
                        
                        BookCacheHelper.SavaBookListAsFile(self.bookList, .Rank)
                    }
                }
                
                super.endLoadData()
            }
            
        }
        
    }
    
    
}

///网络请求数据并返回booklist

extension RankViewController {
    
    
    ///加载网页数据
    fileprivate   func requestData(_ index:Int, completion: @escaping ( _ html:String?  , _ isSucces:Bool) ->())   {
        
        let urlStr =  SoDuUrl.rankPage.replacingOccurrences(of: "_", with: "_\(index + 1)")
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil, completion: completion  )
        
    }
    
    
}


extension RankViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension RankViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
