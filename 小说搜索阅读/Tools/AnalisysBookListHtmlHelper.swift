//
//  AnalisysHtmlHelper.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/19.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class AnalisysBookListHtmlHelper {
    
    ///推荐
    static func analisysRecommendHtml(_ str:String?) -> [Book]  {
        
        return analisysHomeHtml(str,0)
    }
    
    ///最热
    static func analisysHotHtml(_ str:String?) -> [Book]  {
        
        return analisysHomeHtml(str,1)
    }
    
    ///个人书架
    static func analisysBookShelfHtml(_ str:String?) -> [Book]  {
        
        return analisysBookShelfPageHtml(str)
    }
    
    
    ///排行榜
    static func analisysRankHtml(_ str:String?) -> [Book]  {
        
        return analisysRankPageHtml(str)
    }
    
    
    ///搜索结果
    static func analisysSearchHtml(_ str:String?) -> [Book]  {
        
        return analisysRankPageHtml(str)
    }
    
    
    
    ///返回更新列表数据
    static func analisysUpdateChapterHtml(_ str:String?) -> [Book]  {
        
        return analisysUpdateChapterPageHtml(str)
    }
    
    
    ///返回更新列表页的数量
    static func analisysUpdateChapterPageCount(_ str:String?) -> Int {
        
        return  getUpdateChapterPageCount(str!)
        
    }
    
    
}



///具体的实现方法
extension AnalisysBookListHtmlHelper {
    
    /// 推荐是0 热门是1
    fileprivate  static func analisysHomeHtml(_ str:String?,_ type:Int = 0) -> [Book]  {
        
        var  list = [Book]()
        
        var html = str
        
        if(html == nil || html == "") {
            
            return list
        }
        
        
        html = html?.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard  let regx = try? NSRegularExpression(pattern: "<div class=\"main-head\">.*?<table", options: []) else {
            
            return list
        }
        
        let result = regx.matches(in: html!, options:[], range: NSRange(location: 0, length: html!.characters.count))
        
        if result.count == 0 {
            
            return list
        }
        
        let partsHtml = (html! as NSString).substring(with: result[0].range)
        let arrays = partsHtml.components(separatedBy: "<div class=\"main-head\">")
        
        if arrays.count < 4 {
            
            return list
        }
        
        
        let analysisStr = type == 0 ? arrays[2] :arrays[3]
        
        guard let regex = try? NSRegularExpression(pattern: "<div class=\"main-html\".*?class=xt1.*?</div>", options: []) else {
            
            return list
            
        }
        
        let regexResult = regex.matches(in: analysisStr, options: [], range: NSRange(location: 0, length: analysisStr.characters.count))
        
        for  checkRange in  regexResult
        {
            let b = Book()
            
            var item =  (analysisStr as NSString).substring(with: checkRange.range)
            
            let reg = try? NSRegularExpression(pattern: "<div style=\"width:482px;float:left;\"><a.*?href=\"(.*?)\".*?id=\"(.*?)\".*?alt=\"(.*?)\".*?>(.*?)</a><.*?xt1>(.*?)</div>", options: [])
            
            
            guard   let match = reg?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count)) else {
                
                continue
            }
            
            if  match.numberOfRanges < 5 {
                
                continue
            }
            
            
            b.updateListPageUrl = (item as NSString).substring(with: (match.rangeAt(1)))
            
            b.bookId = (item as NSString).substring(with: (match.rangeAt(2)))
            
            b.bookName = (item as NSString).substring(with: (match.rangeAt(3)))
            
            b.chapterName = (item as NSString).substring(with: (match.rangeAt(4)))
            
            b.updateTime = (item as NSString).substring(with: (match.rangeAt(5)))
            
            
            list.append(b)
        }
        
        return list
    }
    
    ///MARK: - 解析排行榜页面数据
    fileprivate static func analisysBookShelfPageHtml(_ str:String?)  -> [Book]  {
        
        var  list = [Book]()
        
        var html = str
        
        if(html == nil || html == "") {
            
            return list
        }
        
        
        
        html = html?.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard  let regx = try? NSRegularExpression(pattern: "<div class=\"main-html\".*?class=\"clearSc\".*?</div>", options: []) else {
            
            return list
        }
        
        
        let result = regx.matches(in: html!, options:[], range: NSRange(location: 0, length: html!.characters.count))
        
        
        
        if result.count == 0 {
            
            return list
        }
        
        
        for  checkRange in  result
        {
            let b = Book()
            
            var  item =  (html! as NSString).substring(with: checkRange.range)
            
            
            let str =  "<a href=\"(.*?)\".*?>(.*?)</a>.*?target=_blank>(.*?)</a>.*?<div.*?>(.*?)</div>.*?id=(.*?)\""
            
            let regex = try? NSRegularExpression(pattern: str, options: [])
            
            let result = regex?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            
            
            if (result?.numberOfRanges)! < 6 {
                
                continue
            }
            
            b.updateListPageUrl = (item as NSString).substring(with: (result?.rangeAt(1))!)
            b.bookName = (item as NSString).substring(with: (result?.rangeAt(2))!)
            b.chapterName = (item as NSString).substring(with: (result?.rangeAt(3))!).replacingOccurrences(of: "target=_blank", with: "")
            b.updateTime = (item as NSString).substring(with: (result?.rangeAt(4))!)
            b.bookId = (item as NSString).substring(with: (result?.rangeAt(5))!)
            
            b.lastReadChapterName = b.chapterName
            
            list.append(b)
        }
        
        print("解析到的数量 \(list.count)")
        
        return list
    }
    
    ///MARK: - 解析排行榜页面数据
    fileprivate static func analisysRankPageHtml(_ str:String?)  -> [Book]  {
        
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
        
        
        
        if result.count == 0 {
            
            return list
        }
        
        
        for  checkRange in  result
        {
            let b = Book()
            
            var  item =  (html! as NSString).substring(with: checkRange.range)
            
            
            let str =  "addToFav\\((.*?), \'(.*?)\'\\).*?<a href=\"(.*?)\".*?>(.*?)</a>.*left;.*?>(.*?)</div>"
            
            let regex = try? NSRegularExpression(pattern: str, options: [])
            
            let result = regex?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            
            if result == nil {
                
                continue
            }
            
            
            if (result?.numberOfRanges)! < 6 {
                
                continue
            }
            
            b.bookId = (item as NSString).substring(with: (result?.rangeAt(1))!)
            b.bookName = (item as NSString).substring(with: (result?.rangeAt(2))!)
            b.updateListPageUrl = (item as NSString).substring(with: (result?.rangeAt(3))!)
            b.chapterName = (item as NSString).substring(with: (result?.rangeAt(4))!)
            b.updateTime = (item as NSString).substring(with: (result?.rangeAt(5))!)
            
            if item.contains("trend-") {
                
                let pattern = "<small class=\"trend-(.*?)\">(.*?)</small>"
                
                let reg = try? NSRegularExpression(pattern: pattern, options: [])
                
                let res = reg?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
                
                
                if res != nil {
                    
                    let changType = (item as NSString).substring(with: (res?.rangeAt(1))!)
                    let value = (item as NSString).substring(with: (res?.rangeAt(2))!)
                    
                    if changType == "up" {
                        
                        b.rankChangeValue =  value
                        
                    } else {
                        
                        b.rankChangeValue =  "-" + value
                    }
                    
                    
                }
            }
            
            
            list.append(b)
        }
        
        print("解析到的数量 \(list.count)")
        
        return list
    }
    
    ///MARK: - 解析更新章节列表页
    fileprivate static func analisysUpdateChapterPageHtml(_ str:String?)  -> [Book]  {
        
        var  list = [Book]()
        
        var html = str
        
        if(html == nil || html == "") {
            
            return list
        }
        
        
        
        html = html?.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard  let regx = try? NSRegularExpression(pattern: "<div class=\"main-html\".*?class=\"xt1.*?</div>", options: []) else {
            
            return list
        }
        
        
        let result = regx.matches(in: html!, options:[], range: NSRange(location: 0, length: html!.characters.count))
        
        
        
        if result.count == 0 {
            
            return list
        }
        
        let lyList = LyWebUrls.instance.getAllValues() as! [String]
        
        for  checkRange in  result
        {
            let b = Book()
            
            var  item =  (html! as NSString).substring(with: checkRange.range)
            
            //chapterurl=(.*?)\".*?alt=\"(.*?)\".*?class=\"tl\">(.*?)</a>.*?xt1\">(.*?)<.div>
            let str =  "chapterurl=(.*?)\".*?alt=\"(.*?)\".*?class=\"tl\">(.*?)</a>.*?xt1\">(.*?)<.div>"
            
            let regex = try? NSRegularExpression(pattern: str, options: [])
            
            let result = regex?.firstMatch(in: item, options: [], range: NSRange(location: 0, length: item.characters.count))
            
            
            if (result?.numberOfRanges)! < 5 {
                
                continue
            }
            
            b.contentPageUrl = (item as NSString).substring(with: (result?.rangeAt(1))!)
            
            
            
            guard   let url = b.contentPageUrl, let uri = URL(string:url),let host = uri.host  else{
                
                continue
            }
            
            if !lyList.contains(host) {
                
                continue
                
            }
            
            
            b.chapterName = (item as NSString).substring(with: (result?.rangeAt(2))!)
            b.lywzName = (item as NSString).substring(with: (result?.rangeAt(3))!)
            b.updateTime = (item as NSString).substring(with: (result?.rangeAt(4))!)
            
            list.append(b)
        }
        
        print("解析到的数量 \(list.count)")
        
        return list
    }
    
    
    
    fileprivate static func getUpdateChapterPageCount(_ html:String) -> Int {
        
        
        let partern = "总计(.*?)个记录，共(.*?)页"
        
        let regex = try? NSRegularExpression(pattern: partern, options:[])
        
        let result = regex?.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.characters.count))
        
        if result?.numberOfRanges == 3 {
            
            let page =  (html as NSString).substring(with: (result?.rangeAt(2))!)
            
            return Int(page.trimmingCharacters(in: NSCharacterSet.whitespaces))!
        }
        
        return 1
    }
    
    
    
}
