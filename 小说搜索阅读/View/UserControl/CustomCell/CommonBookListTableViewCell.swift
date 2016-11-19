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
    
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var txtRank: UILabel!
    
    @IBOutlet weak var imgRank: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          self.separatorInset = UIEdgeInsets.zero
       
        rankView.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
