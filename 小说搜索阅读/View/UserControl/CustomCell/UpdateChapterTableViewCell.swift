//
//  UpdateChapterTableViewCell.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class UpdateChapterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtChapterName: UILabel!
    
    @IBOutlet weak var txtLywzName: UILabel!

    @IBOutlet weak var txtUpdateTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          self.separatorInset = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
