//
//  ColorPickerView.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/10.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import UIKit

class ColorPickerView: UIControl {
    
    var imageView:UIImageView?
    
    var colorSelected: Bool {
        
        didSet {
            
            imageView?.isHidden = !colorSelected
            
        }
        
    }
    
    override init(frame: CGRect) {
        
        colorSelected = false
        
        super.init(frame: frame)
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience  init(frame:CGRect, color:String,isSelected:Bool) {
        
        self.init()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width - 10, height: frame.height - 10));
        
        view.backgroundColor = UIColor.colorWithHexString(hex: color)
        
        view.layer.cornerRadius = view.bounds.width * 0.5;
        
        view.clipsToBounds = true;
        
        self.addSubview(view)
        
        let image =  #imageLiteral(resourceName: "right")
        
        imageView = UIImageView(image: image)
        
        imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        self.addSubview(imageView!)
        
        imageView?.center = view.center
        
        imageView?.isHidden = !isSelected
        
        view.isUserInteractionEnabled = false
        
        imageView?.isUserInteractionEnabled = false
    }
    
    
    
}
