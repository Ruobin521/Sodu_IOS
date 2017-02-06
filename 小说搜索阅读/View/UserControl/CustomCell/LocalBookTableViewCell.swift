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
    
    var vm:LocalBookItemViewModel? {
        
        didSet {
            
            setContent()
            
            vm?.checkUpdateCompletion = { (data:String) in
                
                DispatchQueue.main.async {
                    
                    self.txtUpdateCount.text = data
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
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
}
