//
//  LoadingWidthColoseButtonView.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/29.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class LoadingWidthColoseButtonView: UIView {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    
    class func loadingWidthColoseButtonView() -> LoadingWidthColoseButtonView {
        
        let nib = UINib(nibName: "LoadingWidthColoseButtonView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! LoadingWidthColoseButtonView
        
        v.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        loadingIndicatorView.frame = CGRect(x:0, y:0, width:50, height:50)
        
        loadingIndicatorView.center = v.center
        
        loadingIndicatorView.startAnimating()
        
        v.addSubview(loadingIndicatorView)
        
        
        return v
        
    }
    
    
}




