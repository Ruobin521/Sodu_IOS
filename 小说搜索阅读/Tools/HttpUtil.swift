//
//  HttpUtil.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/10/19.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation
import AFNetworking


enum RequestMethod {
    
    case POST
    case GET
    
}


class  HttpUtil :AFHTTPSessionManager  {
    
    
    static var  instance:HttpUtil =  {
        
        let shared = HttpUtil()
        
   //[manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
       // [urlRequest addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

      
        
        shared.requestSerializer.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
      
        shared.requestSerializer.setValue("gzip, deflate, sdch", forHTTPHeaderField: "Accept-Encoding")
        shared.requestSerializer.timeoutInterval = 10
        
        

        shared.responseSerializer = AFHTTPResponseSerializer()
        shared.responseSerializer.acceptableContentTypes?.insert("text/html")
        shared.responseSerializer.acceptableContentTypes?.insert("application/x-gzip")
        
        
        return shared
        
    }()
    
    
    
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
    
    
    func AFrequest(url:String ,requestMethod: RequestMethod, postStr: String?,parameters: [String: AnyObject]?, timeOut:TimeInterval = 15.0, completion: @escaping (_ result:Any?, _ isSuccess :Bool) ->() )  {
        
        
       
        
        let success  = { (task: URLSessionDataTask? , json: Any?) -> () in
            
            completion(json , true)
//            print(json)
//            
//            var str = String(data:(json as? Data)!, encoding: String.Encoding.utf8)
//            
//            print(str)
            
            
        }
        
        
        let failure  = { (task: URLSessionDataTask?, error: Error?) -> () in
            
            print(task?.response)
            
            completion(nil, false)
            print(error)
            
        }
        
        if requestMethod == .GET {
            
            get(url, parameters: parameters, progress: nil, success: success, failure: failure)
            
        } else {
            
            post(url, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
}
