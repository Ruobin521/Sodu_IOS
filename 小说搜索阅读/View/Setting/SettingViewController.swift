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
    
    
    
    
}


extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  2
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellid = ""
        
        if indexPath.row == 0 {
            
            cellid = commonCellId
            
        } else {
            
            
             cellid =  SwitchCellId
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        cell.selectionStyle = .none
        
       // cell.txtSetting.text = "个人中心"
        
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
