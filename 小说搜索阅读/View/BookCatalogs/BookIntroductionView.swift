//
//  BookIntroductionView.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit
import SDWebImage

class BookIntroductionView: UIView {
    
    
    @IBOutlet weak var coverImage: UIImageView!
    
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtAuthor: UILabel!
    
    @IBOutlet weak var txtLywz: UILabel!
    
    
    @IBOutlet weak var txtIntroduction: UILabel!
    
    
    class func bookIntroductionView(bookName:String?,cover:String?,lywz:String?,author:String?,introduction:String?) -> BookIntroductionView {
        
        let nib = UINib(nibName: "BookIntroductionView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! BookIntroductionView
        
        // let defaultHeight:CGFloat =  15
        
        var height = CGFloat(15 + 110 + 8 + 18 + 5 + 8 + 8)
        
        if let text = introduction {
            
            let viewSize = CGSize(width: UIScreen.main.bounds.width - 30 , height: CGFloat(MAXFLOAT))
            
            v.txtIntroduction.text = text
            
            v.txtIntroduction.font = UIFont.systemFont(ofSize: 15)
            
            let size = v.txtIntroduction.sizeThatFits(CGSize(width: viewSize.width, height: CGFloat(MAXFLOAT)))
            
            height +=  size.height
        
            
        } else {
            
            v.txtIntroduction.text = "简介是什么鬼,章节名称已经说明一切!"
            height +=  17
        }
        
        v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        
        
        v.txtBookName.text = bookName ?? "暂无"
        v.txtAuthor.text = author ?? "某位大神"
        v.txtLywz.text = lywz ?? "某个网站"
        //v.txtIntroduction.text = introduction ?? "暂无"
        
        if let url = cover {
            
            let uri = URL(string: url)
            
            v.coverImage.sd_setImage(with: uri, placeholderImage: UIImage(named: "cover"))
        }
        
        
        return v
        
    }
    
}
