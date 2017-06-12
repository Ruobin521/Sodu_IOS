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
    
    static  func AnalisysHtml(_ urlStr:String, _ html:String, _ type:AnalisysType,_ bookName:String = "") -> Any? {
        
        let url = URL(string: urlStr);
        
        let host = url?.host
        
        var value:Any?
        
        switch host! {
            
        ///第七中文
        case  LyWebUrls.instance.dqzw:
            
            if type == .Content {
                
                value = analisysDqzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisysDqzwCIAC(urlStr,html)
                
            }
            
            
            
        ///七度书屋
        case  LyWebUrls.instance.qdsw:
            
            if type == .Content {
                
                value = analisysQdswHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                value = analisys7dswCIAC(urlStr,html)
            }
            
            
            
            
        ///第九中文网
        case  LyWebUrls.instance.dijiuzww:
            
            if type == .Content {
                
                value = analisysDjzwwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisysDjzwCIAC(urlStr,html)
                
            }
            
            
            
        ///清风小说
        case  LyWebUrls.instance.qfxs:
            
            if type == .Content {
                
                value = analisysQfxsHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisysQfxsCIAC(urlStr,html)
                
            }
            
            
            //        ///窝窝小说网
            //        case  LyWebUrls.instance.wwxsw2:
            //
            //            if type == .Content {
            //
            //                value = analisysDjzwwHtml(urlStr,html)
            //
            //
            //            } else if type == .CatalogPageUrl {
            //
            //                value = analysisCommonCatalogPageUrl(url: urlStr)  + "mulu.html"
            //
            //            } else if type == .CatalogList {
            //
            //                //                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:"", html: html, htmlPattern: "<head>.*?</html>", catalogPattern: "<td class=\"L\".*?href=\"(.*?)\".*?>(.*?)</a></td>", introPattern: "<div class=\"js\">.*?<p><b>", coverPattern: "<div class=\"pic\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "<i>作者：(.*?)</i>")
            //
            //            }
            //
            
        ///大海中文
        case  LyWebUrls.instance.dhzw:
            
            if type == .Content {
                
                value = analisysDhzwHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisys7dswCIAC(urlStr,html)
                
            }
            
            
            
        //爱上中文
        case  LyWebUrls.instance.aszw:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"contents\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:"", html: html, htmlPattern: "<head>.*?</html>", catalogPattern: "<td class=\"L\".*?href=\"(.*?)\".*?>(.*?)</a></td>", introPattern: "<div class=\"js\">.*?<p><b>", coverPattern: "<div class=\"pic\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "<i>作者：(.*?)</i>")
                
            }
            
            
        ///少年文学
        case  LyWebUrls.instance.snwx:
            
            
            if type == .Content {
                
                value = analisysDhzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisys7dswCIAC(urlStr,html)
            }
            
            
        ///手牵手
        case  LyWebUrls.instance.sqsxs:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisysSqsCIAC(urlStr,html)
                
            }
            
        ///找书网
        case  LyWebUrls.instance.zsw:
            
            
            
            if type == .Content {
                
                value = analisyssZswHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value = analisysQfxsCIAC(urlStr,html)
                
                
            }
            
            
        ///  去笔阁网
        case  LyWebUrls.instance.xbiquge:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<dt>《.*?》正文</dt>.*?</div>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<div id=\"intro\">.*?</div>", coverPattern: "<div id=\"fmimg\"><img.*?src=\"(.*?)\".*?>", AuthorPattern: "<p>作&nbsp;&nbsp;&nbsp;&nbsp;者：(.*?)</p>")
            }
            
            
        /// 古古小说
        case  LyWebUrls.instance.ggxs:
            
            if type == .Content {
                
                value = analisyssGgxsHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:baseUrl, html: html, htmlPattern: "<table.*?</table>", catalogPattern: "<td><a href=\"(.*?)\" title=.*?>(.*?)</a></td>", introPattern: "<div class=\"msgarea\">.*?</p>", coverPattern: "<div class=\"img1\"><img src=\"(.*?)\".*?</div>", AuthorPattern: "<a href=\"/modules/article/authorarticle.php\\?author=.*?>(.*?)</a>")
            }
            
        /// 书6
        case  LyWebUrls.instance.shu6:
            
            if type == .Content {
                
                value = analisysDqzwHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let uri = URL(string: urlStr)
                
                let tempUrl = "http://" + (uri?.host!)!
                
                
                value =  analisysCommonCIAC(url: tempUrl,coverBaseUrl:"", html: html, htmlPattern: "<div id=\"content\">.*?</div>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<p class=\"intro\">.*?</p>", coverPattern: "<div class=\"book_info_top_l\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "<p class=\"author\">(.*?)</p>")
                
            }
            
            
        /// 风华居
        case  LyWebUrls.instance.fenghuaju:
            
            if type == .Content {
                
                value = analisysSqsxsHtml(urlStr,html)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:baseUrl, html: html, htmlPattern: "正文</dt>.*?</div>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<div id=\"intro\">.*?</div>", coverPattern: "<div id=\"fmimg\"><img.*?src=\"(.*?)\".*?>", AuthorPattern: "<p>作&nbsp;&nbsp;&nbsp;&nbsp;者：(.*?)</p>")
            }
            
            
            
        /// 云来阁
        case  LyWebUrls.instance.ylg:
            
            if type == .Content {
                
                value = analisyssYlgHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl =  urlStr.replacingOccurrences(of: "index.html", with: "")
                
                value = analisyYlgCIAC(baseUrl,html)
                
                
            }
            
            
        /// 4K中文
        case  LyWebUrls.instance.fourkzw:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                value =  analisysCommonCIAC(url: "",coverBaseUrl:"", html: html, htmlPattern: " <div class=\"book_list\">.*?</div>", catalogPattern: "<li><a href=\"(.*?)\">(.*?)</a></li>", introPattern: " <h3 class=\"bookinfo_intro\">.*?</h3>", coverPattern: "<div class=\'pic\'>.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "<span class=\"item red\">作者：(.*?)</span>")
                
            }
            
            
        /// 幼狮
        case  LyWebUrls.instance.yssm:
            
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"htmlContent\".*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                value =  analisysCommonCIAC(url: "",coverBaseUrl:"", html: html, htmlPattern: "<div class=\"book_list\">.*?</div>", catalogPattern: "<li><a href=\"(.*?)\">(.*?)</a></li>", introPattern: "<h3 class=\"bookinfo_intro\">.*?</h3>", coverPattern: "<div class=\'pic\'>.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "<span class=\"item red\">作者：(.*?)</span>")
                
            }
            
            
            
        ///木鱼哥
        case  LyWebUrls.instance.myg:
            
            
            if type == .Content {
                
                value = analisysMygHtml(urlStr,html,bookName: bookName)
                
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                value =  analisysCommonCIAC(url: "",coverBaseUrl:"", html: html, htmlPattern: "<div id=\"xslist\">.*?</div>", catalogPattern: "<li><a href=\"(.*?)\".*?>(.*?)</a></li>", introPattern: "<p>&nbsp;&nbsp;&nbsp;&nbsp;.*?</p>", coverPattern: "<div id=\"fmimg\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern: "</h1>&nbsp;&nbsp;&nbsp;&nbsp;(.*?)/著</div>")
                
            }
            
            
            
        /// 轻语 (封面。简介在另外一个页面，暂不处理)
        case  LyWebUrls.instance.qyxs:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"content\">.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<div id=\"readerlist\">.*?<div class=\"clearfix\">", catalogPattern: "<li><a href=\"(.*?)\">(.*?)</a></li>", introPattern: "<div id=\"bookintro\">(.*?)</div>", coverPattern: "<div id=\"bookimg\"><img.*?src=\"(.*?)\".*?>", AuthorPattern: "作者：<span><a href=\"/modules/article/authorarticle.php\\?author.*?>(.*?)</a></span>")
                
            }
            
        /// 乐文
        case  LyWebUrls.instance.lww:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"txtright\">.*?<span id=\"endtips\">")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisLwwCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<h2 class=\"bookTitle\">.*?<div id=\"uyan_frame\">", catalogPattern: "<a href=\"(.*?)\">(.*?)</a>", introPattern: "<div class=\"reBook borderF\">(.*?)</div>", coverPattern: "<div style=\"width:600px; padding:5px\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern:"<p>作者：(.*?)&nbsp;&nbsp;&nbsp;</p>")
                
                
            }
            
            
            
            //        /// 去笔趣阁
            //        case  LyWebUrls.instance.qbqg:
            //
            //            if type == .Content {
            //
            //                value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
            //
            //            } else if type == .CatalogPageUrl {
            //
            //                value = analysisCommonCatalogPageUrl(url: urlStr)
            //
            //            } else if type == .CatalogList {
            //
            //
            //                //                let baseUrl = "http://" + host!
            //                //
            //                //                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<h2 class=\"bookTitle\">.*?<div id=\"uyan_frame\">", catalogPattern: "<a href=\"(.*?)\">(.*?)</a>", introPattern: "<div class=\"reBook borderF\">(.*?)</div>", coverPattern: "<div style=\"float:left; margin-right:10px\"><img src=\"(.*?)\".*?>", AuthorPattern:"<p>作者：(.*?)&nbsp;&nbsp;&nbsp;</p>")
            //            }
            //
            
        ///秋水轩
        case  LyWebUrls.instance.qsx:
            
            if type == .Content {
                
                value = analisysQsxHtml(urlStr,html)
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:baseUrl, html: html, htmlPattern: "<div class=\"chapter\">.*?</div>", catalogPattern: "<dd><a href=\"(.*?)\".*?>(.*?)</a></dd>", introPattern: "<div class=\"list\">.*?<div class=\"clear\"></div>", coverPattern: "<div class=\"list\">.*?<img.*?src=\"(.*?)\".*?/>", AuthorPattern:"<span class=\"author\">作者：(.*?)  分类.*?</span>")
                
            }
            
            
            
        /// 卓雅居
        case  LyWebUrls.instance.zyj:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisZyjCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
               
               // let baseUrl = "http://" + host!
                
                value =   analisysDjzwCIAC(urlStr, html)
            }
            
            
            
        /// 81中文网
        case  LyWebUrls.instance.xs81:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"?content\"?.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:baseUrl, html: html, htmlPattern: "<div id=\"list\">.*?</div>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<div id=\"intro\">.*?</div>", coverPattern: "<div id=\"fmimg\"><img.*?src=\"(.*?)\".*?/>", AuthorPattern:"<p>作&nbsp;&nbsp;&nbsp;&nbsp;者：(.*?)</p>")
                
            }
            
        /// 风云  没有封面，简介，作者
        case  LyWebUrls.instance.fyxs:
            
            if type == .Content {
                
                value = analisysCommonHtml(html,"<p id=\"?content\"?.*?</p>")
                
                if(value != nil) {
                    
                    let tempReg = try? NSRegularExpression(pattern: "【无弹窗小说网.*?www.baoliny.com】", options: [])
                    
                    if tempReg != nil {
                        
                        let tempHtml = (value as? String)!
                        
                        value =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
                        
                    }
                    
                    
                    let tempReg2 = try? NSRegularExpression(pattern: "【风云小说阅读网.*?www.baoliny.com】", options: [])
                    
                    if tempReg2 != nil {
                        
                        let tempHtml = (value as? String)!
                        
                        value =  tempReg2!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
                        
                    }
                    
                    
                    
                    let tempReg3 = try? NSRegularExpression(pattern: "【最新章节阅读.*?www.baoliny.com】", options: [])
                    
                    if tempReg3 != nil {
                        
                        let tempHtml = (value as? String)!
                        
                        value =  tempReg3!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
                        
                    }
                    
                    
                    
                }
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr) + "index.html"
                
            } else if type == .CatalogList {
                
                
                value =  analisysCommonCIAC(url: "",coverBaseUrl:"", html: html, htmlPattern: "<div class=\"readerListShow\".*?</div>", catalogPattern: "<td.*?href=\"(.*?)\".*?>(.*?)</a></td>", introPattern: "", coverPattern: "", AuthorPattern:"")
                
            }
            
            
            
        /// 大书包  封面取不到
        case  LyWebUrls.instance.dsb:
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div class=\"hr101\">.*?<span id=\"endtips\">")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisDsbCatalogPageUrl(url: urlStr)
            } else if type == .CatalogList {
                
                
                let baseUrl = "http://" + host!
                
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<h2 class=\"bookTitle\">.*?<div id=\"uyan_frame\">", catalogPattern: "<a href=\"(.*?)\">(.*?)</a>", introPattern: "<div class=\"reBook borderF\">(.*?)</div>", coverPattern: "<div style=\"width:600px; padding:5px\">.*?<img.*?src=\"(.*?)\".*?>", AuthorPattern:"<p>作者：(.*?)&nbsp;&nbsp;&nbsp;</p>")
            }
            
        /// 漂流地
        case  LyWebUrls.instance.pld:
            if type == .Content {
                
                value = analisysCommonHtml(html," <div id=\"BookText\">.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)

                
            } else if type == .CatalogList {
                
                
                let baseUrl = "https://" + host!
                
                
                value =  analisysCommonCIAC(url: baseUrl,coverBaseUrl:"", html: html, htmlPattern: "<dl class=\"chapterlist\">.*?</dl>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<p class=\"book-intro\">(.*?)</p>", coverPattern: "<div class=\"book-img\">.*?<img.*?src=\"(.*?)\".*?/>", AuthorPattern:"<p>作.*?者：(.*?)</p>")
            }
            
        /// 齐鲁文学
        case  LyWebUrls.instance.qlwx:
            if type == .Content {
                
                value = analisysCommonHtml(html,"<div id=\"content\">.*?</div>")
                
            } else if type == .CatalogPageUrl {
                
                value = analysisCommonCatalogPageUrl(url: urlStr)
                
                
            } else if type == .CatalogList {
                
                let baseUrl = "http://" + host!
                
                value =  analisysCommonCIAC(url: urlStr,coverBaseUrl:baseUrl, html: html, htmlPattern: "<dl>.*?</dl>", catalogPattern: "<dd><a href=\"(.*?)\">(.*?)</a></dd>", introPattern: "<div id=\"intro\">(.*?)</div", coverPattern: "<div id=\"fmimg\">.*?<img.*?src=\"(.*?)\".*?/>", AuthorPattern:"<p>作.*?者：(.*?)</p>")
            }
            
            
            
        default:
            
            return nil
        }
        
        return value
    }
    
}

///解析目录，简介，作者，封面
extension AnalisysHtmlHelper {
    
    ///  通用
    static func analisysCommonCIAC(url:String,coverBaseUrl:String,html:String,htmlPattern:String,catalogPattern:String,introPattern:String,coverPattern:String,AuthorPattern:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        
        guard let strRegex = try? NSRegularExpression(pattern: htmlPattern, options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: catalogPattern, options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = url +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: introPattern, options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: coverPattern, options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage = coverBaseUrl +   replaceSymbol(str: coverStr,false)
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: AuthorPattern, options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    
    /// 第七中文
    static func analisysDqzwCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        let uri = URL(string: url)
        
        
        let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<dd><a href=\"/(.*?)\">(.*?)</a></dd>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = baseUrl! +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<p class=\"intro\">.*?</div>", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let  introStr = (str as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div class=\"book_info_top_l\">.*?<img.*?src=\"(.*?)\".*?>", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let coverStr = (str as  NSString).substring(with: match.rangeAt(1))
                
                coverImage = replaceSymbol(str: coverStr,false).trimmingCharacters(in: [" "])
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<p class=\"author\">(.*?)</p>", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let coverStr = (str as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false).trimmingCharacters(in: [" "])
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    /// 第九中文
    static func analisysDjzwCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        let uri = URL(string: url)
        
        
        let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        
        // (?<=<dd>.*?href=\")(.*?)(?=\".*?>(.*?)</a></dd>)
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<dd><a href=\"/(.*?)\">(.*?)</a></dd>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = baseUrl! +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"intro\">.*?</p>", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let  introStr = (str as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"fmimg\"><script.*?src=\"/(.*?)\">", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let coverStr = (str as  NSString).substring(with: match.rangeAt(1))
                
                let url =  "http://" + (uri?.host!)! + "/"
                
                coverImage = url + replaceSymbol(str: coverStr,false)
                 
                
                if let imageHtml =  HttpUtil.instance.httpRequest(urlString: coverImage!) {
                    
                    let partern = "<img.*?src=\'(.*?)\'.*?/>"
                    
                    //封面
                    if  let regex = try? NSRegularExpression(pattern: partern, options: []) {
                        
                        if  let match = regex.firstMatch(in: imageHtml, options: [], range: NSRange(location: 0, length: imageHtml.characters.count)) {
                            
                            let coverStr = (imageHtml as  NSString).substring(with: match.rangeAt(1))
                            
                            coverImage = coverStr
                            
                        }
                        
                    }

                }
                
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<p>作&nbsp;&nbsp;&nbsp;&nbsp;者：(.*?)</p>", options: []) {
            
            if  let match = introRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) {
                
                let coverStr = (str as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false).trimmingCharacters(in: [" "])
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    
    /// 七度书屋  大海中文  少年文学
    static func analisys7dswCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        // let uri = URL(string: url)
        
        
        // let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        guard let strRegex = try? NSRegularExpression(pattern: "<div id=\"list\">.*?</div>", options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        
        //<dd><a href="9494646.html" title="第一章 科技结晶">第一章 科技结晶</a></dd>
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<dd><a href=\"(.*?)\".*?>(.*?)</a></dd>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = url +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<div class=\"intro\">.*?</div>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"fmimg\">.*?<img.*?src=\"(.*?)\".*?>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage =  replaceSymbol(str: coverStr,false)
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<i>作者：(.*?)</i>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    
    ///  清风小说 找书
    static func analisysQfxsCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        let uri = URL(string: url)
        let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        guard let strRegex = try? NSRegularExpression(pattern: "<div class=\"book_list\">.*?</div>", options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<li><a href=\"/(.*?)\".*?>(.*?)</a></li>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = baseUrl! +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<div class=\'upd\'>.*?</div>.*?<p>(.*?)</p>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div class=\'pic\'>.*?src=\"(.*?)\".*?>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage = baseUrl! +  replaceSymbol(str: coverStr,false)
                
                if let cover = coverImage  {
                    
                    if let imageHtml =  HttpUtil.instance.httpRequest(urlString: cover) {
                        
                        let partern = "<img.*?src=\"(.*?)\".*?/>"
                        
                        //封面
                        if  let regex = try? NSRegularExpression(pattern: partern, options: []) {
                            
                            if  let match = regex.firstMatch(in: imageHtml, options: [], range: NSRange(location: 0, length: imageHtml.characters.count)) {
                                
                                let coverStr = (imageHtml as  NSString).substring(with: match.rangeAt(1))
                                
                                coverImage = coverStr
                                
                            }
                            
                        }
                        
                    }

                }
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<li class=\"author\">作者：(.*?)</li>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    ///  手牵手
    static func analisysSqsCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
       // _ = URL(string: url)
     //   _ = uri?.deletingLastPathComponent().absoluteString
        
        
        guard let strRegex = try? NSRegularExpression(pattern: "<div id=\"list\">.*?</div>", options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<dd><a href=\"(.*?)\".*?>(.*?)</a></a></dd>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = url +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"intro\">.*?</div>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"fmimg\">.*?<img.*?src=\"(.*?)\".*?>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage =  replaceSymbol(str: coverStr,false)
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<meta property=\"og:novel:author\" content=\"(.*?)\"/>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    
    ///  古古
    static func analisysGGCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        let uri = URL(string: url)
        let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        guard let strRegex = try? NSRegularExpression(pattern: "<table.*?</table>", options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<dd><a href=\"(.*?)\".*?>(.*?)</a></a></dd>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = url +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"intro\">.*?</div>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.range)
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<div id=\"fmimg\">.*?<img.*?src=\"(.*?)\".*?>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage = baseUrl! +  replaceSymbol(str: coverStr,false)
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<p>作&nbsp;&nbsp;&nbsp;&nbsp;者：(.*？)</p>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
    }
    
    
    /// 云来阁
    static func analisyYlgCIAC(_ url:String,_ html:String) -> (catalogs:[BookCatalog]?, introduction:String?,author:String?, cover:String?)   {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        let htmlValue = str
        
        var catalogs:[BookCatalog] = [BookCatalog]()
        
        var introduction:String?
        
        var coverImage:String?
        
        var authorName:String?
        
        // let uri = URL(string: url)
        
        
        // let baseUrl = uri?.deletingLastPathComponent().absoluteString
        
        
        guard let strRegex = try? NSRegularExpression(pattern: "<table.*?</table>", options: []) else {
            
            return (catalogs,introduction,authorName,coverImage)
        }
        
        guard   let htmlMatch = strRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
            
            return (catalogs,introduction,authorName,coverImage)
            
        }
        
        str =  (str as NSString).substring(with: htmlMatch.range)
        
        
        //<dd><a href="9494646.html" title="第一章 科技结晶">第一章 科技结晶</a></dd>
        
        /// 目录
        if   let regex = try? NSRegularExpression(pattern: "<a href=\"(.*?)\">(.*?)</a>", options: []) {
            
            let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            
            if matches.count == 0 {
                
                return (catalogs,introduction,authorName,coverImage)
            }
            
            for (i,item) in matches.enumerated() {
                
                // let catalogStr = (str as  NSString).substring(with: item.range)
                
                if item.range.length > 2 {
                    
                    let catalog:BookCatalog = BookCatalog()
                    
                    catalog.chapterIndex =  i
                    catalog.chapterUrl = url +  (str as NSString).substring(with: (item.rangeAt(1)))
                    catalog.chapterName =  (str as NSString).substring(with: (item.rangeAt(2)))
                    
                    catalogs.append(catalog)
                }
                
            }
            
        }
        
        
        //简介
        if  let introRegex = try? NSRegularExpression(pattern: "<meta property=\"og:description\" content=\"(.*?)\"/>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let  introStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                introduction = replaceSymbol(str: introStr)
                
            }
            
        }
        
        
        
        
        //封面
        if  let introRegex = try? NSRegularExpression(pattern: "<meta property=\"og:image\" content=\"(.*?)\"/>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                coverImage =  replaceSymbol(str: coverStr,false)
                
            }
            
        }
        
        
        //作者
        if  let introRegex = try? NSRegularExpression(pattern: "<meta property=\"og:novel:author\" content=\"(.*?)\"/>", options: []) {
            
            if  let match = introRegex.firstMatch(in: htmlValue, options: [], range: NSRange(location: 0, length: htmlValue.characters.count)) {
                
                let coverStr = (htmlValue as  NSString).substring(with: match.rangeAt(1))
                
                authorName = replaceSymbol(str: coverStr,false)
            }
            
        }
        
        return  (catalogs,introduction,authorName,coverImage)
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
        
        
        
        let tempReg = try? NSRegularExpression(pattern: "记住.*?\\(.*?\\)", options: [])
        
        if tempReg != nil {
            
            tempHtml =  tempReg!.stringByReplacingMatches(in: tempHtml, options: [], range:NSRange(location: 0, length: tempHtml.characters.count), withTemplate: "")
            
        }
        
        
        tempHtml = replaceSymbol(str: tempHtml)
        tempHtml = tempHtml.replacingOccurrences(of: "书路（www.shu6.cc）最快更新！", with: "")
        
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
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<div id=\"content\">.*?<div class=\"bottomlink tc\">", options: []) else {
            
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
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        return tempHtml
    }
    
    /// 解析木鱼哥
    static func analisysMygHtml(_ url:String,_ html:String,bookName:String) -> String? {
        
        var str = html.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        guard   let reg = try? NSRegularExpression(pattern: "<p class=\"vote\">.*?</div>", options: []) else {
            
            return nil
        }
        
        var listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
        
        if  listHtml == nil {
            
            guard   let reg = try? NSRegularExpression(pattern: "<div id=\"booktext\">.*?<div class=\"row text-center\">", options: []) else {
                
                return nil
            }
            
            listHtml = reg.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            
            if listHtml == nil {
                
                return  nil
                
            }
            
        }
        
        var tempHtml = (str as  NSString).substring(with: listHtml!.range)
        
        
        tempHtml = tempHtml.replacingOccurrences(of: "无弹窗", with: "")
        
        tempHtml = tempHtml.replacingOccurrences(of: "里面更新速度快、广告少、章节完整、破防盗】", with: "")
        
        tempHtml = tempHtml.replacingOccurrences(of: "更新最快，书最齐的小说就是", with: "")
        
        tempHtml = tempHtml.replacingOccurrences(of: bookName, with: "");
        
        tempHtml = tempHtml.replacingOccurrences(of: "[玄界之门http://www.xuanjiexiaoshuo.com/]", with: "")
        
        tempHtml = replaceSymbol(str: tempHtml)
        
        
        return tempHtml
    }
    
    /// 通用解析
    static  func  replaceSymbol(str:String,_ isTrim:Bool = true) -> String {
        
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
        
        
        html = html.replacingOccurrences(of: "&lt;&gt;", with: "")
        html = html.replacingOccurrences(of: "&lt;&gt;", with: "")
        html = html.trimmingCharacters(in: [" ","\n"])
        
        
        if isTrim {
            
            html =  "　　" + html
        }
        
        return    html
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


