//
//  RefreshControl.swift
//  Ruobin微博
//
//  Created by  ruobin on 2016/11/7.
//  Copyright © 2016年  ruobin. All rights reserved.
//

import UIKit


enum RefreshState {
    
    case Normal
    
    case Pulling
    
    case WillRefresh
    
}


/// 刷新控件  负责刷新相关的逻辑处理
class RefreshControl: UIControl {
    
    
    fileprivate let refreshOffset:CGFloat = 60
    
    /// 刷新控件的父控件，下拉刷新控件适用于uitableveiw / collectionview
    fileprivate weak var scrollView :UIScrollView?
    
    
    fileprivate lazy var refreshView = RefreshView.refreshView()
    
    
    init() {
        
        super.init(frame: CGRect())
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    
    func beginRefreshing() {
        
        
        guard let sv = scrollView else {
            
            return
            
        }
        
        if refreshView.refreshState == .WillRefresh {
            
            return
        }
        
        refreshView.refreshState = .WillRefresh
        
        UIView.animate(withDuration: 0.25, animations:  {
            
            var inset = sv.contentInset
            
            inset.top += self.refreshOffset
            
            sv.contentInset = inset
            
        })
        
    }
    
    
    func endRefreshing() {
        
        guard let sv = scrollView else {
            
            return
        }
        
        
        if refreshView.refreshState != .WillRefresh {
            
            return
        }
        
        
        
        //  self.refreshView.refreshState = .Normal
        
        UIView.animate(withDuration: 0.25, animations: {
            
            var inset = sv.contentInset
            
            inset.top -= self.refreshOffset
            
            sv.contentInset = inset
            
        }, completion: { (isSuccess) in
            
            
            self.refreshView.refreshState = .Normal
            
        })
        
        
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        print(newSuperview ?? "wu")
        
        guard let sv = newSuperview as? UIScrollView   else {
            
            return
        }
        
        //记录父视图 contentoffset
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        //print(scrollView?.contentOffset ?? "父视图为空")
        
        
        guard  let sv = scrollView else {
            
            return
            
        }
        
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0  {
            
            return
            
        }
        
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        
        if  sv.isDragging {
            
            
            if  height > refreshOffset  && (refreshView.refreshState == .Normal) {
                
                refreshView.refreshState = .Pulling
                
                
            } else if height <= refreshOffset && (refreshView.refreshState == .Pulling) {
                
                refreshView.refreshState = .Normal
                
            }
            
            
        } else {
            
            // 放手 是否超过临界点
            
            if refreshView.refreshState == .Pulling {
                
                beginRefreshing()
                
                sendActions(for: .valueChanged)
            }
            
        }
        
        
    }
    
    
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        
    }
    
    
}


extension RefreshControl {
    
    
    func setupUI()  {
        
        backgroundColor = superview?.backgroundColor
        
        // clipsToBounds = true
        
        addSubview(refreshView)
        
        
        //自动布局 设置xib的自动布局 需要指定宽高约束
        
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
        
        
        
    }
    
    
}
