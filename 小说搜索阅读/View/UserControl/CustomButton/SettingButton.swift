//
//  SettingButton.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/22.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


@IBDesignable class SettingButton: UIControl {
    
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var imageView: UIImageView?
    
    
    @IBOutlet weak var titleLabel: UILabel?
    
    var actionName:String?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initialFromXib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    
    func initialFromXib() {
        
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: String(describing: SettingButton.self), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
        
         
    }
    
}
