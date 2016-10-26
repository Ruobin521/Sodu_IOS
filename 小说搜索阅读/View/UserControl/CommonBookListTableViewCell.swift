//
//  CommonBookListTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/26.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class CommonBookListTableViewCell: UITableViewCell {

    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtUpdateTime: UILabel!
    
    @IBOutlet weak var txtUpdateChpterName: UILabel!
    
    
    var book:Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
