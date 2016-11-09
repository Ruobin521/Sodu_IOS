//
//  RefreshView.swift
//  RBRefreshControl
//
//  Created by  ruobin on 2016/11/7.
//  Copyright © 2016年  ruobin. All rights reserved.
//

import UIKit



/// 刷新视图，处理动画
class RefreshView: UIView {
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var tipIcon: UIImageView!
    
    
    /// ios中默认顺时针旋转
    /// 就近原则
    var refreshState:RefreshState = .Normal {
        
        didSet {
            
            switch refreshState {
                
            case .Normal:
                
                tipIcon.isHidden = false
                indicator.stopAnimating()
                
                tipLabel.text = "下拉刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.tipIcon.transform = CGAffineTransform.identity
                    
                })
                
                
            case .Pulling:
                
                tipLabel.text = "释放刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                    
                })
                
                
            case .WillRefresh:
                
                tipLabel.text = "加载中..."
                
                //隐藏提示图标
                
                tipIcon.isHidden = true
                
                indicator.startAnimating()
                
                
            }
        }
        
    }
    
    
    class func refreshView() -> RefreshView {
        
        
        let nib = UINib(nibName: "RefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! RefreshView
        
    }
}
