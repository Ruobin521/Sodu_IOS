//
//  WelcomViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/28.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class WelcomView: UIView {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    class func welcomView() -> WelcomView {
        
        
        let nib = UINib(nibName: "WelcomView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WelcomView
        
        v.frame = UIScreen.main.bounds
        
        return v
        
    }
  
    
    
    override func didMoveToWindow() {
        
        
        self.layoutIfNeeded()
        
        bottomConstraint.constant = bounds.size.height - 200
        
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            
            self.layoutIfNeeded()
            
        }) { (isSuccess) in
            
            UIView.animate(withDuration: 1.0, animations: {
                
                self.tipLabel.alpha = 1
                
                }, completion: { (_) in
                    
                    self.removeFromSuperview()
                    
            })
            
            
        }
        
    }

    
   
    
  
   
 
}
