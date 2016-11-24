//
//  BookIntroductionView.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BookIntroductionView: UIView {

    
    
    class func bookIntroductionView(bookName:String?,lywz:String?,author:String?,introduction:String?) -> BookIntroductionView {
        
        let nib = UINib(nibName: "BookIntroductionView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! BookIntroductionView
        
        v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
                 
        return v
        
    }
    
}
