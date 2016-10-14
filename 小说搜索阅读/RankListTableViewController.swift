//
//  RankListTableViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class RankListTableViewController: UITableViewController {
    
    
//    
//    var   bookList = [Book]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        do
//        {
//            
//          try loadData { (list) in
//                
//            
//                    self.bookList+=list
//                    self.tableView.reloadData()
//            
//                
//            }
//            
//            
//        }
//            
//        catch {
//            
//        }
//        
//        
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    ///加载网页数据
//    private  func loadData(completion: @escaping (_ list : [Book]) ->()) throws-> ()    {
//        
//        var html: String?
//        
//        let url = URL(string: "http://www.sodu.cc/top.html")
//        
//        print ("开始加载数据")
//        
//        do {
//            
//            try? URLSession.shared.dataTask(with: url!) { (data, _, error) in
//               
//                if(data == nil)
//                {
//                    return
//                }
//                
//                html = String(data: data!, encoding: .utf8)
//                
//                if  html != nil {
//                    DispatchQueue.main.async {
//                        
//                        completion(self.AnalisysHtml(html))
//                    }
//                    
//                }
//                }.resume()
//            
//        }
//        catch let _ as NSError
//        {
//            
//        }
//        
//        
//    }
//    
//    
//    
//    
//    ///MARK: - 解析排行榜页面数据
//    private func AnalisysHtml(_ str:String?) -> [Book]
//    {
//        var  list = [Book]()
//        
//        var html = str
//        
//        if(html == nil || html == "") {
//            
//            return list
//        }
//        
//        html = html?.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
//        
//        
//        guard  let regx = try? NSRegularExpression(pattern: "<div class=\"main-html\".*?<div style=\"width:88px;float:left;\">.*?</div>", options: []) else {
//            return list
//        }
//        
//        let result = regx.matches(in: html!, options:[], range: NSRange(location: 0, length: html!.characters.count))
//        
//        
//        if result.count==0 {
//            
//            return list
//        }
//        
//        
//        for  checkRange in  result
//        {
//            let b = Book()
//            
//            var  item =  (html! as NSString).substring(with: checkRange.range)
//            
//            let  nameRegx = try? NSRegularExpression(pattern: "addToFav.*?'(.*?)'", options: [])
//            let name = nameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
//            b.bookName = (item as NSString).substring(with: (name?.rangeAt(1))!)
//            
//            let  chapterUpdateUrlRegx = try? NSRegularExpression(pattern: "(?<=<a href=\")(.*?)(?=\">.*?</a>)", options: [])
//            let chapterUpdateUrl = chapterUpdateUrlRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
//            b.updateListPageUrl = (item as NSString).substring(with: (chapterUpdateUrl?.rangeAt(1))!)
//            
//            let  chapterNameRegx = try? NSRegularExpression(pattern: "<a href=\"http.*?title=\"总点击.*?>(.*?)</a>", options: [])
//            let chapterName = chapterNameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
//            b.chapterName = (item as NSString).substring(with: (chapterName?.rangeAt(1))!)
//            
//            list.append(b)
//        }
//        
//        return list
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return bookList.count
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        
//        cell.textLabel?.text = bookList[indexPath.row].bookName
//        
//        cell.detailTextLabel?.text = bookList[indexPath.row].chapterName
//        
//        return cell
//    }
//    
    
    
}
