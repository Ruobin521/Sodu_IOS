//
//  BaseViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     setBackColor()
        
    }
 
}

extension BaseViewController {
    
    func  setBackColor()  {
        
         view.backgroundColor = UIColor.white
    }
    
}
