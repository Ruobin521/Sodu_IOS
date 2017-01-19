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
    
    
    override func viewWillAppear(_ animated: Bool)   {
        
        tableview?.reloadData()
        
    }
    
    
}


extension SettingViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return  5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return vm.secondarySettingList.count
            
        } else if section == 1 {
            
            return vm.switchSettingList.count
            
        }   else if section == 2  {
            
            return 1
            
        }   else {
            
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var setting:SettingEntity?
        
        var list:[SettingEntity]!
        
        if indexPath.section == 0 {
            
            list =  vm.secondarySettingList
            
        } else if indexPath.section == 1 {
            
             list =  vm.switchSettingList
            
        } else{
            
             list =  vm.alterSettingList
        }
        
      
        
        setting  = list[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: commonCellId, for: indexPath) as! SettingTableViewCell
        
        cell.setting = setting
        
        cell.imgIcon.image = UIImage(named: (setting?.icon) ?? "")
        
        cell.txtSetting.text = setting?.title
        
        
        if setting?.settingType == SettingType.Swich {
            
            cell.btnSwitch?.addTarget(self, action: #selector(switchAtion), for: .touchUpInside)
            
            cell.btnSwitch?.isOn = self.vm.getValue((setting?.settingKey)!)
            
            cell.btnSwitch?.tag = (setting?.index)!
            
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 0  {
            
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
            
        } else if  indexPath.section == 2 {
            
            mzsmAction()
            
        }
        
        
       
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
    
    
    
    
    
    
    func mzsmAction() {
       
        let alertController = UIAlertController(title: "免责声明", message: mzsmStr, preferredStyle: .alert)
      
        let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: {
            action in
            
            return
            
        })
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
 
    }
}
