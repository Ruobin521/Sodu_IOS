//
//  SettingTableViewCell.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

  
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var txtSetting: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
