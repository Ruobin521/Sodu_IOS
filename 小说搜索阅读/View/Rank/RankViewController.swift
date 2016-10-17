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
        
        if  isLoading  {
            
            return
        }
        
        pageIndex = 0
        loadDataByPageIndex(0)
        
    }
    
    
    override func loadData() {
        
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
        
        requestData(pageindex) { (list) in
            
            if pageindex == 0 {
                
                self.bookList.removeAll()
                
            }
            
            self.bookList += list
            
            self.tableview?.reloadData()
            
            super.endLoadData()
        }
        
    }
    
    
}

///网络请求数据并返回booklist

extension RankViewController {
    
    
    ///加载网页数据
    func requestData(_ index:Int, completion: @escaping (_ list : [Book]) ->())   {
        
        
        
        var html: String?
        
        
        let urlStr =  "http://www.sodu.cc/top_\(index + 1).html"
        
        let url = URL(string: urlStr)
        
        let request = NSMutableURLRequest.init(url: url!)
        
        // 设置请求超时时间
        
        request.timeoutInterval = 30
        //请求方式，跟OC一样的
        request.httpMethod = "GET"
        
        // request.httpBody = String.init(data: " ", encoding:  String.Encoding.utf8)
        
        print ("开始加载数据第 \(index + 1) 页数据")
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            if(data == nil)
            {
                return
            }
            
            // Thread.sleep(forTimeInterval: 5)
            
            html = String(data: data!, encoding: .utf8)
            
            if  html != nil {
                DispatchQueue.main.async {
                    
                    completion(self.AnalisysHtml(html))
                }
                
            }
            }.resume()
        
    }
    
    
    
    
    ///MARK: - 解析排行榜页面数据
    private func AnalisysHtml(_ str:String?) -> [Book]
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
