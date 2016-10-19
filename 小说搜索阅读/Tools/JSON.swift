//
//  JSON.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/10/19.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

protocol JSON {
    
    func toJSONModel() -> AnyObject?
    
    func toJSONString() -> String?
}


//扩展协议方法
extension JSON {
    //将数据转成可用的JSON模型
    func toJSONModel() -> AnyObject? {
        
        let mirror = Mirror(reflecting: self)
        
        if mirror.children.count > 0  {
            
            var result: [String:AnyObject] = [:]
            for case let (label?, value) in mirror.children {
                
                //print("属性：\(label)     值：\(value)")
                if let jsonValue = value as? JSON {
                    result[label] = jsonValue.toJSONModel()
                }
            }
            
            return result as AnyObject?
        }
        
        return self as AnyObject?
    }
    
    //将数据转成JSON字符串
    func toJSONString() -> String? {
        
        let jsonModel = self.toJSONModel()
        //利用OC的json库转换成OC的NSData，
        let data : NSData! = try? JSONSerialization.data(withJSONObject: jsonModel!, options: []) as NSData!
        //NSData转换成NSString打印输出
        let str = NSString(data:data as Data, encoding: String.Encoding.utf8.rawValue)
      
        return str as String?
    
    }
}

//扩展可选类型，使其遵循JSON协议
extension Optional: JSON {
   
    //可选类型重写toJSONModel()方法
    func toJSONModel() -> AnyObject? {
      
        if let x = self {
            
            if let value = x as? JSON {
                return value.toJSONModel()
          
            }
        }
      
        return nil
    }
}


extension String: JSON { }

extension Int: JSON { }

extension Bool: JSON { }

extension Dictionary:JSON { }


extension Array  where  Element: Book {
   
    //将数据转成可用的JSON模型
    func toJSONModel() -> [Any]? {
        
        var result: [Any] = []
        
        for value in self {
            
            if let jsonValue = value as? JSON, let jsonModel = jsonValue.toJSONModel(){
                
                result.append(jsonModel)
            }
        }
        return result as [Any]?
    }
    
    
    //将数据转成JSON字符串
    func toJSONString() -> String? {
        
        let jsonModel = self.toJSONModel()
        
        //利用OC的json库转换成OC的NSData，
        let data : NSData! = try? JSONSerialization.data(withJSONObject: jsonModel!, options: []) as NSData!
        
        //NSData转换成NSString打印输出
        let str = NSString(data:data as Data, encoding: String.Encoding.utf8.rawValue)
        
        return str as String?
        
    }


}





