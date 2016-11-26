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
        
        shared.requestSerializer.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
        
        shared.requestSerializer.setValue("gzip, deflate, sdch", forHTTPHeaderField: "Accept-Encoding")
       
        
        shared.requestSerializer.willChangeValue(forKey: "timeoutInterval")
        shared.requestSerializer.timeoutInterval = 10
        shared.didChangeValue(forKey: "timeoutInterval")
        
        
        shared.responseSerializer = AFHTTPResponseSerializer()
        shared.responseSerializer.acceptableContentTypes?.insert("text/html")
        shared.responseSerializer.acceptableContentTypes?.insert("application/x-gzip")
        
        
        return shared
        
    }()
    
    
    private var requestCount = 0  {
        
        didSet {
            
            
            if requestCount  <= 0 {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } else {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
        }
        
    }
    
    
    func request(url:String ,requestMethod: RequestMethod, postStr: String?, timeOut:TimeInterval = 15.0, _ isIndicatorVisible:Bool = false, completion: @escaping (_ result:String?, _ isSuccess :Bool) ->() )  {
        
        
        if !NetworkHelper.isNetConnected() {
            
            completion(nil,false)
            
            ToastView.instance.showGlobalToast(content: "请检查网络连接是否正常",false)
            
            print("没有网络连接。。。。")
            
            return
        }
        
        let request = NSMutableURLRequest.init(url: URL(string: url)!)
        
        if isIndicatorVisible {
            
              requestCount += 1
        }
        
      
        
        // 设置请求超时时间
        
        request.timeoutInterval = timeOut
        
        //Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36
        //Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36
        //        request.setValue("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36", forHTTPHeaderField: "User-Agent")
        //
        
        if requestMethod == RequestMethod.GET {
            
            request.httpMethod = "GET"
            
        } else {
            
            request.httpMethod = "POST"
            request.httpBody = postStr?.data(using: String.Encoding.utf8)
            
        }
        
        print ("开始加载数据 \(url) 数据")
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            if isIndicatorVisible {
                
                self.requestCount -= 1
            }
            
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
            
        }
        
        
        let failure  = { (task: URLSessionDataTask?, error: Error?) -> () in
            
            print(task?.response ?? "")
            
            completion(nil, false)
            print(error ?? "")
            
        }
        
        print ("开始加载数据 \(url) 数据")

        
        if requestMethod == .GET {
            
            get(url, parameters: parameters, progress: nil, success: success, failure: failure)
            
        } else {
            
            post(url, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
}
