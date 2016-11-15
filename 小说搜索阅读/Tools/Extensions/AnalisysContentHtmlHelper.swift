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
            
        case  LyWebUrls.qsx:
            
            value = analisysQsxHtml(urlStr,html)
            
            
        default:
            
            break
        }
        
        return value
    }
    
}


extension AnalisysContentHtmlHelper {
    
    
    
    /// 解析秋水轩
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - html: <#html description#>
    /// - Returns: <#return value description#>
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
        
        guard   let tempReg = try? NSRegularExpression(pattern: "如果觉得.*?请把本站网址推荐给您的朋友吧！", options: []) else {
            
            return tempHtml
        }
        
        tempHtml =  tempReg.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
        
        
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    
    
    static  func  replaceSymbol(str:String) -> String {
        
        var html = str
        
        guard   let reg1 = try? NSRegularExpression(pattern: "<br.*?/>", options: []) else {
            
            return html
        }
        
        html =  reg1.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
        
        
        guard   let reg2 = try? NSRegularExpression(pattern: "<script.*?</script>", options: []) else {
            
            return html
        }
        html =  reg2.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        
        
        
        guard   let reg3 = try? NSRegularExpression(pattern: "&nbsp;", options: []) else {
            
            return html
        }
        html =  reg3.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "  ")
        
        
        guard   let reg4 = try? NSRegularExpression(pattern: "<p.*?>", options: []) else {
            
            return html
        }
        html =  reg4.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
        
        
        
        
        guard   let reg5 = try? NSRegularExpression(pattern: "<.*?>", options: []) else {
            
            return html
        }
        html =  reg5.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        
        
        
        guard   let reg6 = try? NSRegularExpression(pattern: "&lt;/script&gt;", options: []) else {
            
            return html
        }
        html =  reg6.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        
        
        guard   let reg7 = try? NSRegularExpression(pattern: "&lt;/div&gt;", options: []) else {
            
            return html
        }
        html =  reg7.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        
        
        guard   let reg8 = try? NSRegularExpression(pattern: "\n\n", options: []) else {
            
            return html
        }
        html =  reg8.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "\n")
        
        
        
        guard   let reg9 = try? NSRegularExpression(pattern: "\\(?未完待续\\)?", options: []) else {
            
            return html
        }
        html =  reg9.stringByReplacingMatches(in: html, options: [], range:NSRange(location: 0, length: html.characters.count), withTemplate: "")
        
        
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
    /// 笔下文学（依依中文网）
    /// </summary>
    static let  bxwx5:String = "www.bxwx5.com";
    /// <summary>
    /// 第九中文网
    /// </summary>
    static let  dijiuzww:String = "dijiuzww.com";
    
    /// <summary>
    /// 清风小说
    /// </summary>
    static let qfxs = "www.qfxs.cc";
    /// <summary>
    /// 窝窝小说网
    /// </summary>
    static let wwxsw = "www.quanxiong.org";
    /// <summary>
    /// 55xs（古古小说）
    /// </summary>
    static let xs55 = "www.55xs.com";
    
    /// <summary>
    /// 风云小说
    /// </summary>
    static let fyxs = "www.baoliny.com";
    
    /// <summary>
    /// 爱上中文
    /// </summary>
    static let aszw520 = "www.aszw520.com";
    
    /// <summary>
    /// 大海中文
    /// </summary>
    static let dhzw = "www.dhzw.com";
    
    /// <summary>
    /// 酷酷看书
    /// </summary>
    static let kkks = "www.kukukanshu.cc";
    
    /// <summary>
    /// 少年文学
    /// </summary>
    static let snwx = "www.snwx.com";
    
    /// <summary>
    /// 手牵手小说
    /// </summary>
    static let sqsxs = "www.sqsxs.com";
    
    /// <summary>
    /// 找书网
    /// </summary>
    static let zsw = "www.zhaodaoshu.com";
    
    /// <summary>
    /// 趣笔阁
    /// </summary>
    static let qubige = "www.qbiquge.com";
    
    /// <summary>
    /// 倚天中文
    /// </summary>
    static let ytzww = "www.ytzww.com";
    
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
    static let su80 = "www.su80.net";
    
    /// <summary>
    ///木鱼哥
    /// </summary>
    static let myg = "www.muyuge.com";
    
    /// <summary>
    ///VIVI小说网（顶点小说）
    /// </summary>
    static let vivi = "www.zkvivi.com";
    
    /// <summary>
    ///轻语小说
    /// </summary>
    static let qyxs = "www.qingyuxiaoshuo.com";
    
    /// <summary>
    /// 乐文
    /// </summary>
    static let lww = "www.lwtxt.net";
    
    /// <summary>
    /// 笔铺阁
    /// </summary>
    static let bpg = "www.bipuge.com";
    
    /// <summary>
    /// 秋水轩
    /// </summary>
    static let qsx:String = "www.qiushuixuan.cc";
    
    /// <summary>
    /// 卓雅居
    /// </summary>
    static let zyj = "www.zhuoyaju.com";
    
}

