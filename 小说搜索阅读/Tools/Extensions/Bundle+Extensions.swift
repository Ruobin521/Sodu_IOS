//
//  Bundle+Extensions.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/14.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

extension Bundle {
    
    var namespace: String  {
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    
    var appVesion : String {
        
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
    }
    
}
