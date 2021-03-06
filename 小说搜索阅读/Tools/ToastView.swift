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
    
    var loadinWindow : UIWindow!
    
    override init() {
        
        super.init()
        
        loadinWindow = createLoadingView()
        loadinWindow.isHidden = true
    }
    
    
    func showLoadingView() {
        
        loadinWindow.isHidden = false
        
    }
    
    func closeLoadingWindows() {
        
        DispatchQueue.main.async {
            
            self.loadinWindow.isHidden = true
        }
        
    }
    
    
    //显示加载圈圈
    func createLoadingView() -> UIWindow {
        
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        let loadingContainerView = UIView()
        loadingContainerView.layer.cornerRadius = 10
        
        loadingContainerView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.3)
        
        
        
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
        window.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)! - 50 )
        window.isHidden = false
        window.addSubview(loadingContainerView)
        
        
        return window
        
    }
    
    
    
    //弹窗文字
    func showToast(content:String , _ isSuccess:Bool = true,_ isCenter:Bool = false, _ duration:CFTimeInterval=1.5) -> UIView {
        
        let frame = CGRect(x: 0, y: 64, width:  isCenter ? (rv?.bounds.width)! - 100 : (rv?.bounds.width)!  , height: 35)
        
        
        let toastContainerView = UIView()
        
        toastContainerView.layer.cornerRadius = isCenter ? 4 : 0
        
        toastContainerView.backgroundColor =  !isSuccess ? UIColor(red:0, green:0, blue:0, alpha: 0.8) :    UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.8)
        
        let toastContentView = UILabel(frame: CGRect(x:0, y:0  , width:frame.width,height: frame.height))
        
        toastContentView.font = UIFont.systemFont(ofSize: 15)
        toastContentView.textColor = UIColor.white
        toastContentView.text = content
        toastContentView.textAlignment = NSTextAlignment.center
        toastContainerView.addSubview(toastContentView)
        toastContainerView.frame =  CGRect(x: 0, y: 0, width:  frame.width , height: frame.height)
        
        let window = UIView()
        window.backgroundColor = UIColor.clear
        window.frame = frame
        
        if isCenter {
            
            window.center = CGPoint(x: (rv?.center.x)!, y:(rv?.bounds.height)! / 3 * 2 + 50)
            
        }
        
        
        window.isHidden = false
        window.addSubview(toastContainerView)
        
        
        toastContainerView.layer.add(AnimationUtil.getToastAnimation(duration: duration), forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            
            self.removeToast(sender: window)
            
        }
        
        return window
    }
    
    
    //全局弹窗文字
    func showGlobalToast(content:String , _ isSuccess:Bool = true, _ isCenter:Bool = false,_ duration:CFTimeInterval = 1.5)  {
        
        let frame = CGRect(x: 0, y: 64, width: isCenter ?  (rv?.bounds.width)! - 30  : (rv?.bounds.width)! , height: 35)
        
        
        let toastContainerView = UIView()
        
        toastContainerView.layer.cornerRadius = isCenter ? 4 : 0
        
        toastContainerView.backgroundColor =  !isSuccess ? UIColor(red:0, green:0, blue:0, alpha: 0.8) :    UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.8)
        
        let toastContentView = UILabel(frame: CGRect(x:0, y:0  , width:frame.width,height: frame.height))
        
        toastContentView.font = UIFont.systemFont(ofSize: 15)
        toastContentView.textColor = UIColor.white
        toastContentView.text = content
        toastContentView.textAlignment = NSTextAlignment.center
        toastContainerView.addSubview(toastContentView)
        toastContainerView.frame =  CGRect(x: 0, y: 0, width:  frame.width , height: frame.height)
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(toastContainerView)
        
        window.center = CGPoint(x: (rv?.center.x)!,y:window.center.y)

        
        if isCenter {
            
            window.center = CGPoint(x: (rv?.center.x)!, y:(rv?.bounds.height)!/3 * 2 + 50)
            
        }
        
        windows.append(window)
        
        toastContainerView.layer.add(AnimationUtil.getToastAnimation(duration: duration), forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            
            self.removeToast(sender: window)
            
        }
        
    }
    
    
    
    //移除当前弹窗
    func removeToast(sender: UIView?) {
        
        if sender is UIWindow {
            
            let index = windows.index(of: sender as! UIWindow)
            windows.remove(at: index!)
            
        }  else {
            
            sender?.removeFromSuperview()
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
        scaleAnimation.keyTimes = [0, 0.5, 1.5]
        scaleAnimation.values = [1, 1, 1]
        scaleAnimation.duration = duration
        
        // 透明度变化动画
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        // opacityAnimaton.keyTimes = [0, 0.4 , 1.5]
        opacityAnimaton.values =  [0.5, 1, 1,0]
        opacityAnimaton.duration = 1.5
        
        // 组动画
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果1. kCAMediaTimingFunctionLinear//线性 2. kCAMediaTimingFunctionEaseIn//淡入 3. kCAMediaTimingFunctionEaseOut//淡出4. kCAMediaTimingFunctionEaseInEaseOut//淡入淡出 5. kCAMediaTimingFunctionDefault//默认
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.duration = duration
        animation.repeatCount = 1// HUGE
        animation.isRemovedOnCompletion = false
        animation.autoreverses = false
        
        ///表示动画保持结束后的状态
        animation.fillMode = kCAFillModeForwards;
        
        
        
        return animation
    }
}
