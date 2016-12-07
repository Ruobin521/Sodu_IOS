//
//  FailedView.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/29.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class FailedView: UIView {
    
    
    class func failedView() -> FailedView {
         
        let nib  = UINib(nibName: "FailedView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! FailedView
        
        v.frame = CGRect(x: 0, y: 0, width: 240, height: 170)
        
        return v
        
    }
    
}
