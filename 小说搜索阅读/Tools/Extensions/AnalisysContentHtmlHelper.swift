//
//  AnalisysContentHtmlHelper.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation


class AnalisysContentHtmlHelper {
    
    static  func AnalisysContentHtml(_ urlStr:String,_ html:String) -> String? {
        
        let url = URL(string: urlStr);
        
        let host = url?.host
        
        var value:String?
        
        switch host! {
            
        ///第七中文
        case  LyWebUrls.dqzw:
            
            value = analisysDqzwHtml(urlStr,html)
            
        ///七度书屋
        case  LyWebUrls.qdsw:
            
            value = analisysQdswHtml(urlStr,html)
            
            
        ///第九中文网
        case  LyWebUrls.dijiuzww:
            
            value = analisysDjzwwHtml(urlStr,html)
            
        ///清风小说
        case  LyWebUrls.qfxs:
            
            value = analisysQfxsHtml(urlStr,html)
            
       
        ///窝窝小说网
        case  LyWebUrls.wwxsw2:
            
            value = analisysDjzwwHtml(urlStr,html)
            
        ///大海中文
        case  LyWebUrls.dhzw:
            
            value = analisysDhzwHtml(urlStr,html)
       
        //爱上中文
        case  LyWebUrls.aszw:
            
        value = analisysCommonHtml(html,"<div id=\"contents\".*?</div>")
            
        ///少年文学
        case  LyWebUrls.snwx:
            
            value = analisysDhzwHtml(urlStr,html)
            
            
        ///手牵手
        case  LyWebUrls.sqsxs:
            
            value = analisysSqsxsHtml(urlStr,html)
            
        ///找书网
        case  LyWebUrls.zsw:
            
            value = analisyssZswHtml(urlStr,html)
            
            
        /// 新笔趣阁
        case  LyWebUrls.xbiquge:
            
            value = analisysSqsxsHtml(urlStr,html)
            
        /// 古古小说
        case  LyWebUrls.ggxs:
            
            value = analisyssGgxsHtml(urlStr,html)
            
        /// 书6
        case  LyWebUrls.shu6:
            
            value = analisysDqzwHtml(urlStr,html)
            
        /// 风华居
        case  LyWebUrls.fenghuaju:
            
            value = analisysSqsxsHtml(urlStr,html)
            
        /// 云来阁
        case  LyWebUrls.ylg:
            
            value = analisyssYlgHtml(urlStr,html)
            
        /// 4K中文
        case  LyWebUrls.fourkzw:
            
            value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")

        /// 幼狮
        case  LyWebUrls.yssm:
            
            value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")

        ///木鱼哥
        case  LyWebUrls.myg:
            
            value = analisysMygHtml(urlStr,html)
            
        /// 轻语
        case  LyWebUrls.qyxs:
            
            value = analisysCommonHtml(html,"<div id=\"content\">.*?</div>")
            
        /// 乐文
        case  LyWebUrls.lww:
            
            value = analisysCommonHtml(html,"<div id=\"txtright\">.*?<span id=\"endtips\">")
            
        /// 去笔趣阁
        case  LyWebUrls.qbqg:
            
            value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
            
        ///秋水轩
        case  LyWebUrls.qsx:
            
            value = analisysQsxHtml(urlStr,html)
            
        /// 卓雅居
        case  LyWebUrls.zyj:
            
            value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
            
        /// 81中文网
        case  LyWebUrls.xs81:
            
            value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")

        /// 风云
        case  LyWebUrls.fyxs:
            
            value = analisysCommonHtml(html,"<p id=\"?content\"?.*?</p>")
            
        /// 大书包
        case  LyWebUrls.dsb:
            
            value = analisysCommonHtml(html,"<div class=\"hr101\">.*?<span id=\"endtips\">")
    
            
        default:
            
            break
        }
        
        return value
    }
    
}


extension AnalisysContentHtmlHelper {
    
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




// MARK: - 需要解析的网站

class LyWebUrls {
    
    /// 第七中文
    /// </summary>
    static let dqzw:String = "www.d7zy.com";
    
    /// <summary>
    /// 7度书屋
    /// </summary>
    static let qdsw:String = "www.7dsw.com";
    
    /// <summary>
    /// 第九中文网
    /// </summary>
    static let  dijiuzww:String = "dijiuzww.com";
    
    /// <summary>
    /// 清风小说
    /// </summary>
    static let qfxs = "www.qfxs.cc";
   

    
    /// <summary>
    /// 窝窝小说网2
    /// </summary>
    static let wwxsw2 = "www.biquge120.com";
    
  
  
    /// <summary>
    /// 大海中文
    /// </summary>
    static let dhzw = "www.dhzw.com";
    
  
    
    /// <summary>
    /// 少年文学
    /// </summary>
    static let snwx = "www.snwx.com";
    
    
    /// <summary>
    /// 爱上中文
    /// </summary>
    static let aszw = "www.aszw8.com";
    
    /// <summary>
    /// 手牵手小说
    /// </summary>
    static let sqsxs = "www.sqsxs.com";
    
    /// <summary>
    /// 找书网
    /// </summary>
    static let zsw = "www.zhaodaoshu.com";
    
    /// <summary>
    /// 新笔趣阁
    /// </summary>
    static let xbiquge = "www.xbiquge.net";
    
    /// <summary>
    /// 古古
    /// </summary>
    static let ggxs = "www.55xs.com";
 
    
  
    /// <summary>
    /// 倚天中文
    /// </summary>
   // static let ytzww = "www.ytzww.com";
    
    /// <summary>
    /// 书路小说
    /// </summary>
    static let shu6 = "www.shu6.cc";
    
    /// <summary>
    /// 风华居
    /// </summary>
    static let fenghuaju = "www.fenghuaju.cc";
    
    /// <summary>
    ///云来阁
    /// </summary>
    static let ylg = "www.yunlaige.com";
    
    /// <summary>
    ///4k中文
    /// </summary>
    static let fourkzw = "www.4kzw.com";
    
    /// <summary>
    ///幼狮书盟
    /// </summary>
    static let yssm = "www.youshishumeng.com";
    
    /// <summary>
    ///80小说
    /// </summary>
   // static let su80 = "www.su80.net";
    
    /// <summary>
    ///木鱼哥
    /// </summary>
    static let myg = "www.muyuge.com";
    
    /// <summary>
    ///VIVI小说网（顶点小说）
    /// </summary>
    //static let vivi = "www.zkvivi.com";
    
    /// <summary>
    ///轻语小说
    /// </summary>
    static let qyxs = "www.qingyuxiaoshuo.com";
    
    /// <summary>
    /// 乐文
    /// </summary>
    static let lww = "www.lwtxt.net";
    
    /// <summary>
    /// 去笔趣阁
    /// </summary>
    static let qbqg = "www.qbiquge.com";
    
    /// <summary>
    /// 笔铺阁
    /// </summary>
    //static let bpg = "www.bipuge.com";
    
    /// <summary>
    /// 秋水轩
    /// </summary>
    static let qsx:String = "www.qiushuixuan.cc";
    
    /// <summary>
    /// 卓雅居
    /// </summary>
    static let zyj = "www.zhuoyaju.com";
    
    
    /// <summary>
    /// 81xs
    /// </summary>
    static let xs81 = "www.81xsw.com";
    
    
    
    /// <summary>
    /// 风云
    /// </summary>
    static let fyxs = "www.baoliny.com";
    
    /// <summary>
    /// 大书包
    /// </summary>
    static let dsb = "www.dashubao.cc";
    
    
}

