//
//  LocalBookTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/11.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import UIKit

class LocalBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtNewChapterName: UILabel!
    
    @IBOutlet weak var txtLastReadChapterName: UILabel!
    
    @IBOutlet weak var txtUpdateCount: UILabel!
    
    @IBOutlet weak var onlineView: UIView!
    
    let cireView = CircleProgressControl()
    
    @IBOutlet weak var newImage: UIImageView!
    
    var vm:LocalBookItemViewModel? {
        
        didSet {
            
            setContent()
            
            vm?.setUpdateDataBlock = {
                
                DispatchQueue.main.async {
                    
                    self.txtUpdateCount.text = self.vm?.updateData
                    
                    self.newImage.isHidden = ((self.vm?.book.isNew) == "1" ? false : true)
                    
                    if (self.vm?.isUpdating)! {
                        
                        self.cireView.isHidden = false
                        self.cireView.value = (self.vm?.updateValue)!
                        
                    } else {
                        
                        self.cireView.isHidden = true
                        
                    }
                }
            }
            
            vm?.setContentBlock = {
                
                DispatchQueue.main.async {
                    
                    self.setContent()
                }
                
            }
            
            
            vm?.updateCompletion = {
                
                DispatchQueue.main.async {
                    
                    self.txtUpdateCount.text = ""
                    
                    self.txtNewChapterName.text = self.vm?.book.chapterName
                    
                    self.cireView.isHidden = true
                    
                    self.onlineView.isHidden = ((self.vm?.book.isLocal) == "2" ? false : true)
                    
                }
                
            }
            
        }
    }
    
    
    func setContent() {
        
        let book = vm?.book
        
        self.txtBookName.text = book?.bookName
        
        self.txtNewChapterName.text = book?.chapterName
        
        self.txtLastReadChapterName.text = book?.lastReadChapterName
        
        self.coverImage.sd_setImage(with:URL(string:book?.coverImage ?? "") , placeholderImage: UIImage(named: "cover"))
        
        self.txtUpdateCount.text = self.vm?.updateData
        
        self.onlineView.isHidden = ((self.vm?.book.isLocal) == "2" ? false : true)
        
        self.cireView.isHidden = !(self.vm?.isUpdating)!
        
        self.newImage.isHidden = ((self.vm?.book.isNew) == "1" ? false : true)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        creatCire()
        
    }
    
    
    func creatCire(){
        
        self.cireView.value = 0
        
        self.cireView.maximumValue = 100
        
        self.cireView.backgroundColor = UIColor.clear
        
        let width:CGFloat = 30
        
        self.cireView.frame = CGRect(x: (self.coverImage.frame.width -  width) * 0.5, y: (self.coverImage.frame.height -  width) * 0.5, width: width, height: width)
        
        //self.cireView.center = self.coverImage.center
        
        self.coverImage.addSubview(cireView)
        
        self.cireView.isHidden = true
        
        // ChangeValue()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
}
