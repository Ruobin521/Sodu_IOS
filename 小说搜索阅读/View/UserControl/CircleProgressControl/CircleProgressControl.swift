//
//  CircleProgressControl.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/2/7.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import UIKit

class CircleProgressControl: UIView {
    
    var value: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var maximumValue: CGFloat = 0 {
        didSet { self.setNeedsDisplay() }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isOpaque = false
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        
        //半径
        let radius:CGFloat = rect.width / 4
        //中心点x
        
        let centerX = rect.midX
        //中心点y
        let centerY = rect.midY
        
        let point = CGPoint(x: centerX, y: centerY)
        //弧度起点
        let startAngle = CGFloat(-90 * M_PI / 180)
        //弧度终点
        let endAngle = CGFloat(((self.value / self.maximumValue) * 360 - 90) ) * CGFloat(M_PI) / 180
        
        //创建一个画布
        let context = UIGraphicsGetCurrentContext()
        
        //画笔颜色
        
        
      //  let lineColor = UIColor.lightGray
        
//        //设置边
//        
//        let ovalPath =    UIBezierPath(ovalIn: rect)
//        
//        ovalPath.lineWidth = 0
//        
//        lineColor.setStroke()
//        
//        ovalPath.stroke()
        
        //context!.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor)
         context!.setStrokeColor(UIColor(red: 255 / 255, green: 255/255, blue: 255/255, alpha: 0.6).cgColor)
        
        //画笔宽度
        context!.setLineWidth(radius * 2)
        
        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
        // CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0)
        
        context?.addArc(center: point, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制路径
        context!.strokePath()
        
//        //画笔颜色
//        
//        context!.setStrokeColor(UIColor(red: 255 , green: 255, blue: 255, alpha: 0.6).cgColor)
//
//        
//        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
//        
//        context?.addArc(center: point, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        
//        
//        //绘制路径
//        context!.strokePath()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
