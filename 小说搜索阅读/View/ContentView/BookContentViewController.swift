//
//  BookContentViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/27.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BookContentViewController: BaseViewController {
    
    var webView:UIWebView?
    
    var currentBook:Book?
    
    
    
    override func initData() {
        
        ToastView.instance.showLoadingView()
        
        webView = UIWebView()
        
        webView?.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        webView?.delegate = self
        
        webView?.backgroundColor = UIColor.white
        
        view.insertSubview(webView!, aboveSubview: tableview!)
        
        
        
        title = currentBook?.chapterName
        
        
        guard   let urlString =  currentBook?.contentPageUrl ,let url = URL(string: urlString) else {
            
            return
        }
        
        let request = URLRequest(url: url)
        
        webView?.loadRequest(request)
        
    }
    
    
    func back() {
        
        dismiss(animated: true, completion: nil)
        
        ToastView.instance.closeLoadingWindos()
        
    }
    
    
}


extension BookContentViewController :UIWebViewDelegate {
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let host = request.url?.host?.replacingOccurrences(of: "m.", with: "").replacingOccurrences(of: "www.", with: "")
        
        
        if currentBook != nil  && currentBook?.contentPageUrl != nil  &&  URL(string: (currentBook?.contentPageUrl)!)?.host?.replacingOccurrences(of: "www.", with: "") == host {
            
            return true
        }
        
        return false
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        isLoading = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        isLoading = false
    }
    
    
    
}
