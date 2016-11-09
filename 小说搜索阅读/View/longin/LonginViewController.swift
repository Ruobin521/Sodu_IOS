//
//  LonginViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class LonginViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!

    @IBOutlet weak var txtPasswd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
    @IBAction func login(_ sender: Any) {
        
        
        
    }

    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
}
