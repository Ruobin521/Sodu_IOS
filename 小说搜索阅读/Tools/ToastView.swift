//
//  ToastView.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/18.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class ToastView : NSObject{
    
    static var instance : ToastView = ToastView()
    
    var windows = UIApplication.shared.windows
    let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
    
    var loadinWindow : UIWindow?
    
    //显示加载圈圈
    func showLoadingView() {
        clear()
        let frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        
        let loadingContainerView = UIView()
        loadingContainerView.layer.cornerRadius = 10
        
        loadingContainerView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.5)
        
        //loadingContainerView.backgroundColor = loadingContainerView.tintColor
        
        let indicatorWidthHeight :CGFloat = 40
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loadingIndicatorView.frame = CGRect(x:frame.width/2 - indicatorWidthHeight/2, y:frame.height/2 - indicatorWidthHeight/2, width:indicatorWidthHeight, height:indicatorWidthHeight)
        loadingIndicatorView.startAnimating()
        loadingContainerView.addSubview(loadingIndicatorView)
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = frame
        loadingContainerView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)!)
        window.isHidden = false
        window.addSubview(loadingContainerView)
        
        
        loadinWindow = window
        
        windows.append(window)
        
    }
    
    func closeLoadingWindos() {
        
        DispatchQueue.main.async {
            
            if self.loadinWindow != nil {
               
                self.removeToast(sender: self.loadinWindow)
                self.loadinWindow = nil
                
            }
            
        }
        
    }
    
    //弹窗文字
    func showToast(content:String , _ isSuccess:Bool = true, _ duration:CFTimeInterval=1.0) {
        
        let frame = CGRect(x: 0, y: 0, width: (rv?.bounds.width)!  , height: 30)
        
        
        let toastContainerView = UIView()
        
        toastContainerView.layer.cornerRadius = 0
        
        
        
        toastContainerView.backgroundColor =  !isSuccess ? UIColor(red:0, green:0, blue:0, alpha: 0.5) :    UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.75)
        
        //        var iconWidthHeight :CGFloat = 0
        
        //
        //        if imageName != nil  {
        //
        //            frame = CGRect(x: 0, y: 0, width: 150  , height: 90)
        //
        //            iconWidthHeight = 36
        //
        //            let toastIconView = UIImageView(image: UIImage(named: imageName!)!)
        //            toastIconView.frame = CGRect(x:(frame.width - iconWidthHeight)/2, y:15, width:iconWidthHeight,height: iconWidthHeight)
        //            toastContainerView.addSubview(toastIconView)
        //        }
        //
        
        let toastContentView = UILabel(frame: CGRect(x:0, y:0  , width:frame.width,height: frame.height))
        
        toastContentView.font = UIFont.systemFont(ofSize: 15)
        toastContentView.textColor = UIColor.white
        toastContentView.text = content
        toastContentView.textAlignment = NSTextAlignment.center
        toastContainerView.addSubview(toastContentView)
        
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = frame
        toastContainerView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.center = CGPoint(x: (rv?.center.x)!, y: 80)
        window.isHidden = false
        window.addSubview(toastContainerView)
        windows.append(window)
        
        toastContainerView.layer.add(AnimationUtil.getToastAnimation(duration: duration), forKey: nil)
        
        // perform(#selector(removeToast(sender:self)), with: window, afterDelay: duration)
        
        perform(#selector(removeToast), with: window, afterDelay: duration )
    }
    
    
    //移除当前弹窗
    func removeToast(sender: UIWindow?) {
        
        if let temp = sender  {
            
            let index =  windows.index(of: temp)
            windows.remove(at: index!)
        }
    }
    
    //清除所有弹窗
    func clear() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        windows.removeAll(keepingCapacity: false)
    }
    
}

class AnimationUtil{
    
    //弹窗动画
    static func getToastAnimation(duration:CFTimeInterval = 1.5) -> CAAnimation{
        // 大小变化动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 1, 1]
        scaleAnimation.duration = duration
        
        // 透明度变化动画
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.5 , 1]
        opacityAnimaton.values =  [0.5, 1,1]
        opacityAnimaton.duration = duration
        
        // 组动画
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果1. kCAMediaTimingFunctionLinear//线性 2. kCAMediaTimingFunctionEaseIn//淡入 3. kCAMediaTimingFunctionEaseOut//淡出4. kCAMediaTimingFunctionEaseInEaseOut//淡入淡出 5. kCAMediaTimingFunctionDefault//默认
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.duration = duration
        animation.repeatCount = 1// HUGE
        animation.isRemovedOnCompletion = false
        animation.autoreverses = false
        //  animation.e
        
        
        return animation
    }
}
