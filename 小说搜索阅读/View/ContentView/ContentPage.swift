//
//  ContentPage.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class ContentPage: UIView {
    
    
    @IBOutlet weak var txtChptterName: UILabel!
    
    
    @IBOutlet weak var txtBattery: UILabel!
    
    
    @IBOutlet weak var txtTime: UILabel!
    
    
    @IBOutlet weak var txtContent: UILabel!
    
    @IBOutlet weak var txtChapterIndex: UILabel!
    
    @IBOutlet weak var txtPageIndex: UILabel!
    
    class func contentPage(_ chapterName:String?,_ content:String?,_ battery:String?,_ time:String?,_ textAttributeDic:[String:Any]?,_ chapterIndex:String?, _ pageIndex:String?) -> ContentPage {
        
        let nib  = UINib(nibName: "ContentPage", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ContentPage
        
        v.frame = UIScreen.main.bounds
        
        
        v.txtChptterName.text  = chapterName ?? "加载中"
        
        v.txtContent.text = content ??  ""
        
        v.txtBattery.text = battery ?? "加载中"
        
        v.txtTime.text = time  ?? "加载中"
        
        v.txtPageIndex.text = pageIndex
        
        v.txtChapterIndex.text = chapterIndex
        
        v.setTextAttribute(textAttributeDic)
        
        v.txtContent.textAlignment = .left
        
        return v
        
    }
    
    
    
    func setTextAttribute(_ attributes:[String:Any]?) {
        
        
        
        if let dic = attributes   {
            
            self.txtContent.attributedText = NSAttributedString(string:self.txtContent.text!, attributes:dic)
            
            let color = self.txtContent.textColor
            
            self.txtTime.textColor = color
            
            self.txtChptterName.textColor = color
            
            self.txtBattery.textColor = color
            
            self.txtChapterIndex.textColor = color
            
            self.txtPageIndex.textColor = color
            
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let p = touches.first?.location(in: self.superview)  else{
            
            return
        }
        
        let height = self.bounds.height
        let width = self.bounds.width
        
        if p.x > width * 1 / 3 && p.x < width * 2 / 3  &&  p.y > height * 1 / 3 && p.y < height * 2 / 3  {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
            
        }
        
    }
    
}
