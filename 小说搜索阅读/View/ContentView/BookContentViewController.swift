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
    
    var isShowMenu: Bool = false  {
        
        didSet {
            
            topMenu.isHidden = !isShowMenu
            UIApplication.shared.isStatusBarHidden = !isShowMenu
            
        }
        
        
    }
    
    @IBOutlet weak var txtChapterName: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var txtBattary: UILabel!
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var topMenu: UIView!
    
    @IBOutlet weak var txtTime: UILabel!
    
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
                self?.errorView.alpha = 0.8
            }
            
            
            DispatchQueue.main.async {
                
                self?.loadingWindow.isHidden = true
            }
            
        }
    }
    
    
    
    @IBAction func closeAciton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        
    }
    
}




// MARK: - 设置相关
extension BookContentViewController {
    
    
    func  showSetting() {
        
        isShowMenu = !isShowMenu
    }
    
}



// MARK: -  初始化
extension BookContentViewController {
    
    
    func setupUI() {
        
        UIApplication.shared.isStatusBarHidden = true
        
        errorView?.isHidden = true
        
        topMenu.isHidden = true
        
        txtBookName.text = currentBook?.bookName
        
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
            
            timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTiemInfo), userInfo: nil, repeats: true)
           
            //timer?.fire()
      
        } else {
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let dateString = formatter.string(from: Date())
            
            txtTime.text = dateString
            
        }
        
    }
    
    
    
    
    func battaryChanged(level:Float)  {
        
        if level == -1 {
            
            txtBattary.text = "电量:\(Int(level*100))%"
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
        UIApplication.shared.isStatusBarHidden = false
        
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


