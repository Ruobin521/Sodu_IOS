//
//  SettingViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/17.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let commonCellId = "commonCellId"

class SettingViewController: BaseViewController {
    
    let vm = ViewModelInstance.instance.setting
    
    
}


extension SettingViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return vm.secondarySettingList.count
            
        } else if section == 1 {
            
            return vm.switchSettingList.count
            
        }  else {
            
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var setting:SettingEntity?
        
        let list =  indexPath.section == 0 ? vm.secondarySettingList :  vm.switchSettingList
        
        setting  = list[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: commonCellId, for: indexPath) as! SettingTableViewCell
        
        cell.setting = setting
        
        cell.imgIcon.image = UIImage(named: (setting?.icon) ?? "")
        
        cell.txtSetting.text = setting?.title
        
        cell.btnSwitch?.addTarget(self, action: #selector(switchAtion), for: .touchUpInside)
        
        cell.btnSwitch?.tag = setting?.index ??  0
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section != 0  {
            
            return
            
        }
        
        if indexPath.row == 0  && !ViewModelInstance.instance.userLogon {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NeedLoginNotification), object: nil)
            return
            
        }
      
        
        let setting = vm.secondarySettingList[indexPath.row]
        
        guard let clsName = setting.controller  else {
            
            showToast(content: "该功能暂未实现")
            
            return
        }
        
        guard  let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? BaseViewController.Type  else {
            
            return
        }
        
        
        let vc = cls.init()
        
        vc.title = setting.title
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SettingViewController {
    
    func switchAtion(sender:Any?) {
        
        guard  let btnSwitch = sender as? UISwitch else {
            
            return
            
        }
        
        let index = btnSwitch.tag
        
        guard  let setting =  vm.switchSettingList.first(where: { (item) -> Bool in
            
            item.index == index
            
        }) else {
            
            return
        }
        
        
        if setting.settingKey != nil {
            
            vm.setValue((setting.settingKey)!,btnSwitch.isOn)
             
        }
        
    }
    
    
}


extension SettingViewController {
    
    override func setupUI() {
        
        setBackColor()
        setUpNavigationBar()
        setupTableview()
        
        let cellNib1 = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableview?.register(cellNib1, forCellReuseIdentifier: commonCellId)
    }
    
}
