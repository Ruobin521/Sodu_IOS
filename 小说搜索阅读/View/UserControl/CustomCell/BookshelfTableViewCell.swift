//
//  BookshelfTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BookshelfTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtUpdateTime: UILabel!
    
    @IBOutlet weak var txtUpdateChpterName: UILabel!
    
    @IBOutlet weak var txtLastReadChapterName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
          self.separatorInset = UIEdgeInsets.zero
    }

 
    
    
    
}
