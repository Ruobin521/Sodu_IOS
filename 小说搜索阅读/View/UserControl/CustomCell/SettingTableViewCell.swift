//
//  SettingTableViewCell.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/9.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    var setting:SettingEntity? {
        
        didSet {
            
            if setting?.settingType == SettingType.Swich {
                
                self.accessoryType = .none
                self.selectionStyle = .none
                self.btnSwitch?.isOn = self.setting?.value as? Bool ?? false
                self.btnSwitch?.isHidden = false

            } else {
                
                self.accessoryType = .disclosureIndicator
                self.selectionStyle = .default
                self.btnSwitch?.isHidden = true
            }
        }
    }
    
    
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var txtSetting: UILabel!
    
    
    @IBOutlet weak var btnSwitch: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}


