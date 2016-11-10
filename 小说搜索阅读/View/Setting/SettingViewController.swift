//
//  SettingViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/17.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let commonCellId = "commonCellId"
private let SwitchCellId = "SwitchCellId"


class SettingViewController: BaseViewController {
    
    let vm = SettingPageViewModel()
    
    
}


extension SettingViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return vm.secondarySettingList.count
            
        }else if section == 1 {
            
            return vm.switchSettingList.count
            
        }  else {
            
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellid = ""
        
        let setting:SettingEntity?
        
        if indexPath.section == 0 {
            
            setting = vm.secondarySettingList[indexPath.row]
            
        } else if indexPath.section == 1 {
            
               setting = vm.switchSettingList[indexPath.row]
        } else {
            
            
            setting = nil
        }
        
        
        if setting?.type  ==  SettingType.Secondary {
            
            cellid = commonCellId
            
        } else  if setting?.type  ==  SettingType.Swich {
            
            cellid =  SwitchCellId
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! SettingTableViewCell
        
        cell.setting = setting
        
        cell.imgIcon.image = UIImage(named: (setting?.icon!)!)
        
        cell.txtSetting.text = setting?.txtTitle
        
        
        
        return cell
    }
    
    
}


extension SettingViewController {
    
    override func setupUI() {
        
        setBackColor()
        setUpNavigationBar()
        setuoTableview()
        
        
        
        let cellNib1 = UINib(nibName: "SettingTableViewCell", bundle: nil)
        
        tableview?.register(cellNib1, forCellReuseIdentifier: commonCellId)
        
        
        let cellNib2 = UINib(nibName: "SettingSwitchTableViewCell", bundle: nil)
        
        tableview?.register(cellNib2, forCellReuseIdentifier: SwitchCellId)
        
        
    }
    
}
