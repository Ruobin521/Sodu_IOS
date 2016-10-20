//
//  HttpUtil.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/19.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

enum RequestMethod {
    
    case POST
    case GET
    
}


class  HttpUtil {
    
    static let  instance = HttpUtil()
     
    
    func request(url:String ,requestMethod: RequestMethod, postStr: String?, timeOut:TimeInterval = 15.0, completion: @escaping (_ result:String?, _ isSuccess :Bool) ->() )  {
        
        
        let request = NSMutableURLRequest.init(url: URL(string: url)!)
        
        // 设置请求超时时间
        
        request.timeoutInterval = timeOut
        
        
        if requestMethod == RequestMethod.GET {
            
            request.httpMethod = "GET"
            
        } else {
            
            request.httpMethod = "POST"
            request.httpBody = postStr?.data(using: String.Encoding.utf8)
        }
        
        print ("开始加载数据 \(url) 数据")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            
            guard let _ = data , let  html = String(data: data!, encoding: .utf8) else {
                
                  completion(nil,false)
                  return
            }
            
            completion(html,true)
            
            }.resume()
        
    }
    
}
