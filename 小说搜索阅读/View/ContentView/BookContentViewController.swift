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
    
    var timer:Timer?
    
    var loadingWindow:UIWindow!
    
    var isLoading = false
    
    var isShowMenu: Bool = false
    
    var isShowing = false
    
    
    @IBOutlet weak var txtChapterName: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var txtBattary: UILabel!
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var topMenu: UIView!
    @IBOutlet weak var botomMenu: UIView!
    
    @IBOutlet weak var txtTime: UILabel!
    
    
    @IBOutlet weak var btnRetry: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        initData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettingBar), name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
    }
    
    
    
    func initData() {
        
        loadingWindow.isHidden = false
        
        guard let url =   vm.currentBook?.contentPageUrl  else{
            
            return
        }
        
        txtChapterName.text = vm.currentBook?.chapterName
        
        
         
        
        
        vm.getCuttentChapterContent(url: url) { [weak self] (isSuccess) in
            
            if  isSuccess {
                
                self?.txtContent.text = self?.vm.curentChapterText
                
                self?.setTextContetAttributes()
                
            } else {
                
                self?.btnRetry .isHidden = false
                self?.errorView.isHidden = false
                
            }
            
            DispatchQueue.main.async {
                
                self?.loadingWindow.isHidden = true
            }
            
        }
        
        
        vm.getBookCatalogs(url: url) { [weak self] (isSuccess) in
            
            if  isSuccess {
                
                
                
                
            } else {
                
                
                
            }
            
            DispatchQueue.main.async {
                
                self?.loadingWindow.isHidden = true
            }
            
        }
    }
    
    
    @IBAction func retryAction(_ sender: Any) {
        
        
        errorView.isHidden = true
        
        btnRetry .isHidden = true
        
        initData()
    }
    
    @IBAction func closeAciton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
}




// MARK: - 设置相关
extension BookContentViewController {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isShowMenu {
            
            
            guard  let p = touches.first?.location(in: self.view)  else{
                
                return
            }
            
            print(p)
            
            let height = self.view.bounds.height
            let width = self.view.bounds.width
            
            if p.x > width * 1 / 3 && p.x < width * 2 / 3  &&  p.y > height * 1 / 3 && p.y < height * 2 / 3  {
                
                showSettingBar()
                
            }
        }
        
    }
    
    
    
    func  showSettingBar() {
        
        if isShowing {
            
            return
        }
        
        isShowing = true
        
        print(isShowMenu)
        
        if !isShowMenu {
            
            isShowMenu = true
            
            self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
            
            self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
            
            
            self.topMenu.isHidden = false
            
            self.botomMenu.isHidden = false
            
            txtContent.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.topMenu.transform = CGAffineTransform(translationX: 0, y: 0)
                
                self.botomMenu.transform = CGAffineTransform(translationX: 0, y: 0)
                
                UIApplication.shared.setStatusBarHidden(false, with: .slide)
                
            }, completion: { (isSucess) in
                
                // UIApplication.shared.isStatusBarHidden = false
                
                self.isShowing = false
                
            })
            
        } else {
            
            isShowMenu = false
            
            txtContent.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.topMenu.transform = CGAffineTransform(translationX: 0, y: -self.topMenu.frame.height)
                
                self.botomMenu.transform = CGAffineTransform(translationX: 0, y: self.botomMenu.frame.height)
                
                
                UIApplication.shared.setStatusBarHidden(true, with: .slide)
                
                
            }, completion: { (isSuccess) in
                
                self.topMenu.isHidden = true
                
                self.botomMenu.isHidden = true
                
                self.isShowing = false
            })
            
        }
        
        
    }
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    func setupUI() {
        
        UIApplication.shared.isStatusBarHidden = true
        
        errorView?.isHidden = true
        
        topMenu.isHidden = true
        
        botomMenu.isHidden = true
        
        btnRetry.isHidden = true
        
        txtBookName.text = vm.currentBook?.bookName
        
        loadingWindow = ToastView.instance.createLoadingView()
        
        loadingWindow.center = CGPoint(x: self.errorView.center.x, y: self.errorView.center.y - 20)
        
        txtContent.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 8)
        txtContent.textAlignment = .left
        
        
        setBattaryInfo()
        setTiemInfo()
        
    }
    
    func setBattaryInfo() {
        
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        txtBattary.text = "电量:\(Int(device.batteryLevel*100))%"
        
        NotificationCenter.default.addObserver(self, selector: #selector(battaryChanged), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: device.batteryLevel)
        
    }
    
    func setTiemInfo() {
        
        if timer == nil {
            
            timer =  Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(setTiemInfo), userInfo: nil, repeats: true)
            
            timer?.fire()
            
        } else {
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateString = formatter.string(from: Date())
            
            txtTime.text = dateString
            
        }
        
    }
    
    
    
    
    func battaryChanged(level:Float)  {
        
        if level == -1 {
            
            txtBattary.text = "电量:加载中"
        } else {
            
            txtBattary.text = "电量:\(Int(level*100))%"
        }
        
    }
    
    
    
    func  setTextContetAttributes() {
        
        
        var  dic:[String:Any] = [:]
        
        
        // dic[NSFontAttributeName] = UIFont(name: "PingFangSC-Regular", size: CGFloat(vm.fontSize))
        dic[NSFontAttributeName] =  UIFont.systemFont(ofSize: CGFloat(vm.fontSize))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(8)
        
        dic[NSParagraphStyleAttributeName] = paragraphStyle
        
        dic[NSForegroundColorAttributeName] = #colorLiteral(red: 0.1058823529, green: 0.2392156863, blue: 0.1450980392, alpha: 1)
        
        txtContent.attributedText = NSAttributedString(string: txtContent.text, attributes:dic)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        self.loadingWindow.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = false
        
        timer?.invalidate()
        
    }
    
    
}

extension UITextView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let p = touches.first?.location(in: self.superview)  else{
            
            return
        }
        
        print(p)
        
        let height = self.bounds.height
        let width = self.bounds.width
        
        if p.x > width * 1 / 3 && p.x < width * 2 / 3  &&  p.y > height * 1 / 3 && p.y < height * 2 / 3  {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: touchBeginNotification), object: nil)
            
        }
        
        
    }
    
    
}


