//
//  UIImage+Extensions.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/12/4.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    
    static func imageWithColor(color:UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
}
