//
//  RankListTableViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class RankListTableViewController: UITableViewController {
    
    
    
    var   bookList = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadData { (list) in
            
            self.bookList+=list
            
            self.tableView.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private  func loadData(completion: @escaping (_ list : [Book]) ->())-> ()    {
        
        var html: String?
        
        let url = URL(string: "http://www.sodu.cc/top.html")
        
        print ("开始加载数据")
        
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            
            html = String(data: data!, encoding: .utf8)
            print (html)
            
            if  html != nil {
                DispatchQueue.main.async {
                    
                    completion(self.AnalisysHtml(html))
                }
                
            }
            }.resume()
    }
    
//    public static ObservableCollection<BookEntity> GetRankListFromHtml(string html)
//    {
//    html = html.Replace("\r", "").Replace("\t", "").Replace("\n", "");
//    
//    ObservableCollection<BookEntity> t_list = new ObservableCollection<BookEntity>();
//    
//    MatchCollection matches = Regex.Matches(html, "<div class=\"main-html\".*?<div style=\"width:88px;float:left;\">.*?</div>");
//    if (matches.Count == 0)
//    {
//    t_list = null;
//    return t_list;
//    }
//    
//    BookEntity t_entity;
//    for (int i = 0; i < matches.Count; i++)
//    {
//    t_entity = new BookEntity();
//    
//    try
//    {
//    Match match = Regex.Match(matches[i].ToString(), "<a href=\"javascript.*?</a>");
//    
//    
//    t_entity.BookName = Regex.Match(match.ToString(), "(?<=addToFav\\(.*?').*?(?=')").ToString();
//    t_entity.UpdateCatalogUrl = Regex.Match(matches[i].ToString(), "(?<=<a href=\").*?(?=\">.*?</a>)").ToString();
//    t_entity.BookID = Regex.Match(match.ToString(), "(?<=id=\").*?(?=\")").ToString().Replace("a", "");
//    t_entity.NewestChapterName = Regex.Match(matches[i].ToString(), "(?<=<a href.*?>).*?(?=</a>)", RegexOptions.RightToLeft).ToString();
//    Match match2 = Regex.Match(matches[i].ToString(), "(<div.*?>).*?(?=</div>)", RegexOptions.RightToLeft);
//    t_entity.UpdateTime = Regex.Replace(match2.ToString(), "<.*?>", "");
//    t_list.Add(t_entity);
//    }
//    catch
//    {
//    t_list = null;
//    return t_list;
//    }
//    }
//    return t_list;
//    }
    
    
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

        
        if result == nil {
            
            return list
        }
        
        
        for  checkRange in  result
        {
            let b = Book()
            
            var  item =  (html! as NSString).substring(with: checkRange.range)
            
            let  nameRegx = try? NSRegularExpression(pattern: "addToFav.*?'(.*?)'", options: [])
            let name = nameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            b.bookName = (item as NSString).substring(with: (name?.rangeAt(1))!)
            
//            let  chapterUpdateUrlRegx = try? NSRegularExpression(pattern: "(?<=<a href=\").*?(?=\">.*?</a>)", options: [])
//            let chapterUpdateUrl = chapterUpdateUrlRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
//            b.updateListPageUrl = (item as NSString).substring(with: (chapterName?.rangeAt(1))!)
            
            let  chapterNameRegx = try? NSRegularExpression(pattern: "<a href=\"http.*?title=\"总点击.*?>(.*?)</a>", options: [])
            let chapterName = chapterNameRegx?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            b.chapterName = (item as NSString).substring(with: (chapterName?.rangeAt(1))!)

            list.append(b)

            
          //print (item)
        }
        
        
//        for _ in 0...10 {
//            
//            let b = Book()
//            b.bookName = "遮天"
//            b.chapterName = "大结局"
//            
//            list.append(b)
//        }
//        
    
        return list
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = bookList[indexPath.row].bookName
        
        cell.detailTextLabel?.text = bookList[indexPath.row].chapterName
        
        return cell
    }
    
    
    
}
