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
            
            if setting?.type == SettingType.Swich {
                
                self.accessoryType = .none
                self.selectionStyle = .none
                
                DispatchQueue.main.async {
                    
                    self.btnSwitch?.isOn = self.setting?.value as? Bool ?? false
                }
                
                btnSwitch?.addTarget(self, action: #selector(OnSwitchAction), for: .touchUpInside)
            }
        }
    }
    
    
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var txtSetting: UILabel!
    
    
    @IBOutlet weak var btnSwitch: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    func OnSwitchAction(obj:Any) {
        
        UserDefaultsHelper.setUserDefaultsValueForKey(key:  (self.setting?.key!)!, value: btnSwitch!.isOn)
        
    }
    
}


