//
//  SettingButton.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/22.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


class SettingButton: UIControl {
    
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var imageView: UIImageView?
    
    
    @IBOutlet weak var titleLabel: UILabel?
    
     
    
    
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
        
        contentView.isUserInteractionEnabled = false
        
        self.isUserInteractionEnabled = true
        
        self.addTarget(self, action: #selector(setHeightlightedBackgroundColor), for: .touchDown)
        self.addTarget(self, action: #selector(setNormalBackgroundColor), for: .touchUpOutside)
        self.addTarget(self, action: #selector(setNormalBackgroundColor), for: .touchUpInside)
    }
    
    
    
    func setHeightlightedBackgroundColor() {
        
        self.contentView.backgroundColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    func setNormalBackgroundColor() {
        
        self.contentView.backgroundColor =   UIColor.clear
        
    }
    
}
