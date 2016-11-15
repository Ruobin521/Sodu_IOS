//
//  BookContentViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/15.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

let touchBeginNotification = "touchBeginNotification"

class BookContentViewController: UIViewController {
    
    let vm = BookContentPageViewModel()
    
    var loadingWindow:UIWindow!
    
    var isLoading = false
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtChapterName: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var errorView: UIView!
    
    var currentBook:Book?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        initData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSetting), name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
    }
    
    
    
    func initData() {
        
        loadingWindow.isHidden = false
        
        guard let url =   currentBook?.contentPageUrl  else{
            
            return
        }
        
        txtChapterName.text = currentBook?.chapterName
        
        vm.getCuttentChapterContent(url: url) { [weak self] (isSuccess) in
            
            if  isSuccess {
                
                self?.txtContent.isHidden = false
                self?.errorView.isHidden = true
                
                self?.txtContent.text = self?.vm.curentChapterText
                
                self?.setTextContetAttributes()
                
            } else {
                
                self?.errorView.isHidden = false
                self?.errorView.alpha = 1
                //  self?.txtContent.isHidden = true
                
            }
            
            
            DispatchQueue.main.async {
                
                self?.loadingWindow.isHidden = true
            }
            
        }
    }
    
    
    
    @IBAction func closeAciton() {
        
        dismiss(animated: true, completion: nil)
        
        // ToastView.instance.closeLoadingWindos()
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}




// MARK: - 设置相关
extension BookContentViewController {
    
    
    func  showSetting() {
        
        btnClose.isHidden = !btnClose.isHidden
        
    }
    
    
    
    
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    func setupUI() {
        
        UIApplication.shared.isStatusBarHidden = true
        
        errorView?.isHidden = true
        
        btnClose.isHidden = true
        
        loadingWindow = ToastView.instance.createLoadingView()
        
        loadingWindow.center = self.errorView.center
        
        
        txtContent.textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 5)
        txtContent.textAlignment = .left
        
        
    }
    
    
    func  setTextContetAttributes() {
        
        
        var  dic:[String:Any?] =  [:]
        
        
        dic[NSFontAttributeName] = UIFont(name: "Sinhala Sangam MN 19.0", size: CGFloat(vm.fontSize))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(vm.lineSpace)

        dic[NSParagraphStyleAttributeName] = paragraphStyle
        
        dic[NSForegroundColorAttributeName] = #colorLiteral(red: 0.1058823529, green: 0.2392156863, blue: 0.1450980392, alpha: 1)
        
        txtContent.attributedText = NSAttributedString(string: txtContent.text, attributes:dic)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        UIApplication.shared.isStatusBarHidden = false
        
    }
    
    
}

extension UITextView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
    }
    
    
}


