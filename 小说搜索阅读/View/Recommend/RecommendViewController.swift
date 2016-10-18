//
//  RecommendViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit



private let cellId = "cellId"

class RecommendViewController: BaseViewController {
    
    lazy var bookList = [Book]()
    
    let pageCount = 8
    
    var pageIndex = 0
    
    
    override func InitData() {
        
        if  isLoading  {
            
            return
        }
        
        pageIndex = 0
        loadDataByPageIndex(0)
        
    }
    
    
    
    
    override func pullDownToLoadData() {
        
        refreshControl?.endRefreshing()
        
        InitData()
    }
    
    override func pullUpToloadData() {
        
        if  isLoading  || pageIndex == pageCount - 1 {
            
            return
        }
        
        pageIndex += 1
        
        isPullup = true
        
        loadDataByPageIndex(pageIndex)
        
    }
    
    
    
    func loadDataByPageIndex(_ pageindex: Int) {
        
        isLoading = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        ToastView.instance.showLoadingView()
        
        requestData(pageindex) { (html,isSuccess) in
            
            if !isSuccess {
                
                ToastView.instance.showToast(content: "第\(pageindex+1)页数据加载失败",nil)
                
                return
            }
            
            
            if pageindex == 0 {
                
                self.bookList.removeAll()
                
            }
            
            let tempList =   self.analisysHtml(html)
            
            DispatchQueue.main.async {
                
                self.bookList += tempList
                
                self.tableview?.reloadData()
                
                super.endLoadData()
                
                ToastView.instance.showToast(content: "已加载推荐阅读数据",nil)
                
            }
        }
        
    }
    
    
}

///网络请求数据并返回booklist

extension RecommendViewController {
    
    
    ///加载网页数据
    fileprivate   func requestData(_ index:Int, completion: @escaping ( _ html:String?  , _ isSucces:Bool) ->())   {
        
        let urlStr =  "http://www.sodu.cc/top_\(index + 1).html"
        
        HttpUtil.instance.request(url: urlStr, requestMethod: .GET, postStr: nil, completion: completion  )
        
    }
    
    
    
    
    ///MARK: - 解析排行榜页面数据
    fileprivate func analisysHtml(_ str:String?) -> [Book]
    {
        var  list = [Book]()
        
        var html = str
        
        if(html == nil || html == "") {
            
            return list
        }
        
        html = html?.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard  let regx = try? NSRegularExpression(pattern: "<div class=\"main-html\".*?<div style=\"width:88px;float:left;\">.*?</div>", options: []) else {
            return list
        }
        
        let result = regx.matches(in: html!, options:[], range: NSRange(location: 0, length: html!.characters.count))
        
        if result.count==0 {
            
            return list
        }
        
        for  checkRange in  result
        {
            let b = Book()
            
            var  item =  (html! as NSString).substring(with: checkRange.range)
            
            let  nameRegx = try? NSRegularExpression(pattern: "addToFav.*?'(.*?)'", options: [])
            let name = nameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            b.bookName = (item as NSString).substring(with: (name?.rangeAt(1))!)
            
            let  chapterUpdateUrlRegx = try? NSRegularExpression(pattern: "(?<=<a href=\")(.*?)(?=\">.*?</a>)", options: [])
            let chapterUpdateUrl = chapterUpdateUrlRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            b.updateListPageUrl = (item as NSString).substring(with: (chapterUpdateUrl?.rangeAt(1))!)
            
            let  chapterNameRegx = try? NSRegularExpression(pattern: "<a href=\"http.*?title=\"总点击.*?>(.*?)</a>", options: [])
            let chapterName = chapterNameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            b.chapterName = (item as NSString).substring(with: (chapterName?.rangeAt(1))!)
            
            list.append(b)
        }
        
        return list
    }
    
    
    
    
}


extension RecommendViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        return cell
    }
    
}


extension RecommendViewController {
    
    
    override func setupUI() {
        
        super.setupUI()
        
        tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}
