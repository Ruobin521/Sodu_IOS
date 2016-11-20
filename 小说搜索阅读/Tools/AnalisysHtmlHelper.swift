//
//  AnalisysContentHtmlHelper.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


enum AnalisysType {
    case  Content
    case  CatalogPageUrl
    case  CatalogList
}

class AnalisysHtmlHelper {
    
    static  func AnalisysHtml(_ urlStr:String, _ html:String, _ type:AnalisysType) -> String? {
        
        let url = URL(string: urlStr);
        
        let host = url?.host
        
        var value:String?
        
        switch host! {
            
        ///第七中文
        case  LyWebUrls.dqzw:
            
            if type == .Content {
                
                value = analisysDqzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        ///七度书屋
        case  LyWebUrls.qdsw:
            
            if type == .Content {
                
                value = analisysQdswHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
            
        ///第九中文网
        case  LyWebUrls.dijiuzww:
            
            if type == .Content {
                
                value = analisysDjzwwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        ///清风小说
        case  LyWebUrls.qfxs:
            
            if type == .Content {
                
                value = analisysQfxsHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        ///窝窝小说网
        case  LyWebUrls.wwxsw2:
            
            if type == .Content {
                
                value = analisysDjzwwHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)  + "mulu.html"
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        ///大海中文
        case  LyWebUrls.dhzw:
            
            if type == .Content {
                
                value = analisysDhzwHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        //爱上中文
        case  LyWebUrls.aszw:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"contents\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        ///少年文学
        case  LyWebUrls.snwx:
            
            
            if type == .Content {
                
                value = analisysDhzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        ///手牵手
        case  LyWebUrls.sqsxs:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
        ///找书网
        case  LyWebUrls.zsw:
            
            
            
            if type == .Content {
                
                value = analisyssZswHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        /// 新笔趣阁
        case  LyWebUrls.xbiquge:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        /// 古古小说
        case  LyWebUrls.ggxs:
            
            if type == .Content {
                
                value = analisyssGgxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
        /// 书6
        case  LyWebUrls.shu6:
            
            if type == .Content {
                
                value = analisysDqzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        /// 风华居
        case  LyWebUrls.fenghuaju:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        /// 云来阁
        case  LyWebUrls.ylg:
            
            if type == .Content {
                
                value = analisyssYlgHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        /// 4K中文
        case  LyWebUrls.fourkzw:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
        /// 幼狮
        case  LyWebUrls.yssm:
            
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        ///木鱼哥
        case  LyWebUrls.myg:
            
            
            if type == .Content {
                
                value = analisysMygHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
            
            
        /// 轻语
        case  LyWebUrls.qyxs:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"content\">.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
        /// 乐文
        case  LyWebUrls.lww:
            
            if type == .Content {
                
                 value = analisysCommonHtml(html,"<div id=\"txtright\">.*?<span id=\"endtips\">")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisLwwCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }

             
            
        /// 去笔趣阁
        case  LyWebUrls.qbqg:
            
            if type == .Content {
                
              value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
           
            
        ///秋水轩
        case  LyWebUrls.qsx:
            
            if type == .Content {
                
                value = analisysQsxHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
           
            
        /// 卓雅居
        case  LyWebUrls.zyj:
            
            if type == .Content {
                
                 value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisZyjCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
          
            
        /// 81中文网
        case  LyWebUrls.xs81:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                
            }
            
           
            
        /// 风云
        case  LyWebUrls.fyxs:
            
            if type == .Content {
                
                 value = analisysCommonHtml(html,"<p id=\"?content\"?.*?</p>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr) + "index.html"
                
            } else if type == .CatalogList {
                
                
                
            }
            
          
            
        /// 大书包
        case  LyWebUrls.dsb:
            if type == .Content {
                
                 value = analisysCommonHtml(html,"<div class=\"hr101\">.*?<span id=\"endtips\">")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisDsbCatalogPageUrl(url: urlStr)
            } else if type == .CatalogList {
                
                
                
            }
            
           
            
        default:
            
            return nil
        }
        
        return value
    }
    
}

///解析正文
extension AnalisysHtmlHelper {
    
    static func analisysCommonHtml(_ html:String,_ partern:String) ->String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: partern, options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
        
    }
    
    
    /// 第七中文  书6
    static func analisysDqzwHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div class=\"chapter_con\".*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        tempHtml = tempHtml.replacingOccurrences(of: "书路（www.shu6.cc）最快更新！", with: "")
        
        let tempReg = try? NSRegularExpression(pattern: "记住.*?\\(.*?\\)", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    
    /// 解析七度书屋
    static func analisysQdswHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"BookText\">.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "【看无弹窗.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 大海中文  少年文学
    static func analisysDhzwHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"BookText\">.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "【看无弹窗.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 第九中文 窝窝小说网
    static func analisysDjzwwHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"?content\"?.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 清风小说
    static func analisysQfxsHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"htmlContent\".*?<div class=\"chapter_Turnpage\">", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 手牵手  新笔趣阁 风华居
    static func analisysSqsxsHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"content\">.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 找书网
    static func analisyssZswHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"htmlContent\".*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 古古
    static func analisyssGgxsHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<dd id=\"contents\".*?</dd>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 云来阁
    static func analisyssYlgHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"content\".*?<div class=\"tc\".*?>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        tempHtml = tempHtml.replacingOccurrences(of: "本书最快更新网站请百度搜索：云/来/阁，或者直接访问网站http://www.yunlaige.com", with: "")
        
        
        let tempReg = try? NSRegularExpression(pattern: "里面小说.*?破防盗】", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 解析秋水轩
    static func analisysQsxHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"booktext\">.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        
        tempHtml = tempHtml.replacingOccurrences(of: "一秒记住秋水轩：qiushuixuan.cc", with: "")
        tempHtml = tempHtml.replacingOccurrences(of: "秋水轩", with: "")
        tempHtml = tempHtml.replacingOccurrences(of: "www.qiushuixuan.cc", with: "")
        
        let tempReg = try? NSRegularExpression(pattern: "如果觉得.*?请把本站网址推荐给您的朋友吧！", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 解析木鱼哥
    static func analisysMygHtml(_ url:String,_ html:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<p class=\"vote\">.*?</div>", options: []) else {
            
            return nil
        }
        
        guard  let listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return nil
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml.range)
        
        
        tempHtml = tempHtml.replacingOccurrences(of: "无弹窗", with: "")
        tempHtml = tempHtml.replacingOccurrences(of: "里面更新速度快、广告少、章节完整、破防盗】", with: "")
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 通用解析
    static  func  replaceSymbol(str:String) -> String {
        
        var html = str
        
        let reg1 = try? NSRegularExpression(pattern: "<br.*?/>", options: [])
        
        if reg1  != nil {
            
            html =  reg1!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
            
        }
        
        
        
        let reg2 = try? NSRegularExpression(pattern: "<script.*?</script>", options: [])
        if reg2  != nil {
            
            html =  reg2!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        }
        
        
        
        
        let reg3 = try? NSRegularExpression(pattern: "&nbsp;", options: [])
        if reg3  != nil {
            
            html =  reg3!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "  ")
            
        }
        
        
        let reg4 = try? NSRegularExpression(pattern: "<p.*?>", options: [])
        if reg4  != nil {
            
            html =  reg4!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
            
        }
        
        
        
        let reg5 = try? NSRegularExpression(pattern: "<.*?>", options: [])
        if reg5 != nil {
            
            html =  reg5!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
            
        }
        
        
        
        
        let reg6 = try? NSRegularExpression(pattern: "&lt;/script&gt;", options: [])
        
        if reg6 != nil {
            
            html =  reg6!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        }
        
        
        
        let reg7 = try? NSRegularExpression(pattern: "&lt;/div&gt;", options: [])
        if reg7 != nil {
            
            html =  reg7!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
            
        }
        
        
        
        
        let reg8 = try? NSRegularExpression(pattern: "\n\n", options: [])
        if reg8 != nil {
            
            html =  reg8!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
            
        }
        
        //        let reg9 = try? NSRegularExpression(pattern: "\\(?未完待续。?\\)?", options: [])
        //        if reg9 != nil {
        //
        //            html =  reg9!.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        //        }
        
        
        html = html.trimmingCharacters(in: [" ","\n"])
        
        return "　　" + html
    }
    
}



///解析目录地址
extension AnalisysHtmlHelper {
    
    static func analysisCommonCatalogPageUrl( url:String) -> String {
        
        let offset = lastIndexof(url, "/") + 1
        
        if offset == -1 {
            
            return  ""
        }
        
        let index = url.index(url.startIndex, offsetBy: offset)
        
        
        let result = url.substring(to: index)
        
        
        return result;
    }
    
    
    /// 乐文网
    static func analysisLwwCatalogPageUrl( url:String) -> String {
        
        //        //http://www.lwtxt.net/html/1213_694101.html
        //        // http://www.lwtxt.net/modules/article/reader.php?aid=1213
      
        let index1 = lastIndexof(url, "/") + 1
        let index2 = lastIndexof(url, "_")
         
        let bookid =  (url as NSString).substring(with: NSRange(location: index1,length: index2 - index1))
        
        let  result = "http://www.lwtxt.net/modules/article/reader.php?aid=" + bookid;
        
        return result;
    }
    
    
    /// 大书包
    static func analysisDsbCatalogPageUrl( url:String) -> String {
        
         //http://www.dashubao.cc/html/57509_22892059.html
         // http://www.dashubao.cc/modules/article/reader.php?aid=57509
        
        let index1 = lastIndexof(url, "/") + 1
        let index2 = lastIndexof(url, "_")
        
        let bookid =  (url as NSString).substring(with: NSRange(location: index1,length: index2 - index1))
        
        let  result = "http://www.dashubao.cc/modules/article/reader.php?aid=" + bookid;
        
        return result;
    }
    
    
    /// 卓雅居
    static func analysisZyjCatalogPageUrl( url:String) -> String {
        
        //        //http://www.zhuoyaju.com/7/7103/8204585.html
        //        // http://www.zhuoyaju.com/book/7103.html
        
        let uri = URL(string: url);
        
        let host = uri?.host
        
        guard  let bookid = uri?.pathComponents[2] else {
            
            return ""
        }
        
        let  result = "http://\((host)!)/book/\(bookid).html"
        
        return result;
    }
    
    
    
    
    static func lastIndexof(_ of:String,_ by:String) -> Int {
        
        var index = -1
        
        var i = -1
        
        for   ch in  of.characters {
            
            i += 1
            
            if  String(ch) == by {
                
                index = i
            }
        }
        
        return index
    }
    
}

