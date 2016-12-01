//
//  NSObject+Extensions.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/1.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation

extension NSObject {
    
    func getValueOfProperty(key:String) -> Any? {
        
        let allPropertys = self.getAllPropertys()
        
        if  allPropertys.contains(key)  {
            
            return self.value(forKey: key)
            
        }
        else {
            
            return nil
        }
        
    }
    
    
    func setValueOfProperty(key:String,value:Any) -> Bool{
       
        let allPropertys = self.getAllPropertys()
        
        if(allPropertys.contains(key)){
           
            self.setValue(value, forKey: key)
           
            return true
            
        } else{
            
            return false
        }
    }
    
    
    func getAllValues() -> [Any] {
        
        var result = [Any]()
        
        let allPropertys = self.getAllPropertys()
        
        if allPropertys.count > 0 {
            
            for key  in allPropertys {
                
                if  let value = self.value(forKey: key){
                    
                    result.append(value)
                    
                }
            }
            
        }
        
        return result
        
    }
    
    
    func getAllPropertys()->[String]{
        
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0 ..< countInt  {
            
            let temp = buff?[i]
            
            let tempPro = property_getName(temp)
            
            let proper =   String.init(cString: tempPro!)
            
            result.append(proper)
            
        }
        
        return result
    }
    
    
}
