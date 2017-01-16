//
//  TiebaWebViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/16.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import UIKit
import WebKit

class TiebaWebViewController: BaseViewController {
    
    var webView:WKWebView!
    
    var progressView : UIProgressView? = nil
    
    let keyPathForProgress : String = "estimatedProgress"
    
    var webUrl:String?
    
    override func initData() {
        
        loadUrl(url: webUrl)
        
    }
    
    func loadUrl(url:String?) {
        
        guard let tiebaUrl = url else{
            
            return
        }
        
        let request = URLRequest(url:URL(string: tiebaUrl)!)
        
        webView.load(request)
        
    }
    
    deinit {
        
        webView.removeObserver(self, forKeyPath: keyPathForProgress)
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        
    }
}


extension TiebaWebViewController {
    
    
    override func setupUI() {
        
        setBackColor()
        setUpNavigationBar()
        setupWebView()
    }
    
    
    func setupWebView() {
        
        let rec  = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
        
        webView = WKWebView(frame: rec)
        
        webView.uiDelegate = self
        
        webView.navigationDelegate = self
        
        //   webView.s = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(webView)
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width, height: 4))
        
        progressView!.tintColor =  UIColor.green
        
        webView.addSubview(progressView!)
        
        webView.addObserver(self, forKeyPath: keyPathForProgress, options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old], context: nil)
    }
    
    
    
}

extension TiebaWebViewController:WKUIDelegate,WKNavigationDelegate {
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if ((object as AnyObject).isEqual(webView)  && (keyPath! == keyPathForProgress) ) {
            
            guard  let newProgress = (change![NSKeyValueChangeKey.newKey] as AnyObject).doubleValue,
                let oldProgress = (change![NSKeyValueChangeKey.oldKey] as AnyObject).doubleValue else {
                    
                    return
            }
            
            if newProgress < oldProgress {
                return
            }
            
            if newProgress >= 1 {
                
                progressView!.isHidden = true
                progressView!.setProgress(0, animated: false)
                
            } else {
                
                progressView!.isHidden = false
                progressView!.setProgress(Float(newProgress), animated: true)
                
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
}
