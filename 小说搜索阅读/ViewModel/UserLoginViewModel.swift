//
//  UserLoginViewModel.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/10.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import Foundation



/// 用户登录，注册，注销逻辑
class UserLoginViewModel  {
    
    
    func userLogin(_ userName:String,_ passwd:String,completion:@escaping (_ isSuccess:Bool)->()) {
        
        let url = SoDuUrl.loginPostPage
        
        let postData = "username=\(urlEncode(userName))&userpass=\(urlEncode(passwd))"
        
        
        ToastView.instance.showLoadingView()
        
        HttpUtil.instance.request(url: url, requestMethod: .POST, postStr: postData) { (str, isSuccess) in
            
            if  str != nil && (str?.contains("true"))!  && (str?.contains("success"))! {
                
                
                completion(true)
                
            } else {
                
                completion(false)
                
            }
            
            ToastView.instance.closeLoadingWindos()
            
        }
    }
    
}


extension UserLoginViewModel {
    
    
    func urlEncode(_ str:String) -> String {
        
        var st = str
        
        st =  str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        return st
        
    }
    
}



// MARK: - cookie相关
extension UserLoginViewModel {
    
    /// 记录cookie
    func setCoookie()  {
        
        let cookies =   HTTPCookieStorage.shared.cookies(for:  URL.init(string: SoDuUrl.homePage)!)
        
        guard   let cookie = cookies?.first(where: { (item) -> Bool in
            
            item.name == "sodu_user"
            
        }) else {
            
            return
        }
        
        
        let tempcookie =   HTTPCookie(properties: [HTTPCookiePropertyKey.name     :  cookie.name ,
                                                   HTTPCookiePropertyKey.value    :  cookie.value ,
                                                   HTTPCookiePropertyKey.domain   :  cookie.domain,
                                                   HTTPCookiePropertyKey.path     :  cookie.path,
                                                   HTTPCookiePropertyKey.version  :  cookie.version,
                                                   HTTPCookiePropertyKey.expires  :  Date(timeIntervalSinceNow: 60*60*24*365*2)
            
            ])
        
        
        HTTPCookieStorage.shared.setCookie(tempcookie!)
        
    }
    
    
    /// 删除cookie
    func deleteCoookie()  {
        
        let cookies =   HTTPCookieStorage.shared.cookies(for:  URL.init(string: SoDuUrl.homePage)!)
        
        guard   let cookie = cookies?.first(where: { (item) -> Bool in
            
            item.name == "sodu_user"
            
        }) else {
            
            return
        }
        
        
        HTTPCookieStorage.shared.deleteCookie(cookie)
    }
    
    
    
}
