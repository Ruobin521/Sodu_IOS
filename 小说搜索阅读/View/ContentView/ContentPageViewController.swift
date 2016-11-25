//
//  ContentPageViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/25.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class ContentPageViewController: UIViewController {
    
    
    @IBOutlet weak var txtChptterName: UILabel!
    
    
    @IBOutlet weak var txtBattery: UILabel!
    
    
    @IBOutlet weak var txtTime: UILabel!
    
    @IBOutlet weak var txtContent: UILabel!
    
    
    var chapterName:String?
    
    var content:String?
    
    var battery:String?
    
    var time:String?
    
    var tag:Int = -1
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        txtChptterName.text  = chapterName
        
        txtContent.text = content
        
        txtBattery.text = battery
        
        txtTime.text = time
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

     
    
    
}
