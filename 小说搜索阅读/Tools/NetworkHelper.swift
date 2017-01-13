//
//  NetworkHelper.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/28.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import ReachabilitySwift



enum NetTpye {
    
    case  WIFI
    case WWAN
    case NONE
    
}


///网络连接以及网络连接类型
class NetworkHelper {
    
    
    static  let shared = NetworkHelper()
    
    var reachability =  Reachability()
    
    
    func isNetConnected() -> Bool {
        
        return  NetworkHelper.shared.reachability!.isReachable
        
    }
    
    func isWifi() -> Bool {
        
        return GetNetType() == NetTpye.WIFI
        
    }
    
    func GetNetType() -> NetTpye  {
        
        if   (NetworkHelper.shared.reachability?.isReachableViaWiFi)!  {
            
            return NetTpye.WIFI
            
        } else if  (NetworkHelper.shared.reachability?.isReachableViaWWAN)! {
            
            return NetTpye.WWAN
            
        } else {
            
            return NetTpye.NONE
            
        }
        
    }
    
    
}
