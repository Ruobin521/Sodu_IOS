//
//  DownloadTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/12/8.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var processView: UIProgressView!
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtProcessValue: UILabel!
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    var vm:DownLoadItemViewModel? {
        
        didSet {
            
            txtBookName.text = vm?.book?.bookName
            
            setText()
            
            initTimer()
         
        }
        
    }
    
    
    var timer:Timer?
    
    
    override func awakeFromNib() {
        
        setupHighlightedBack()
        
    }
    
    
    func initTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProcessValue), userInfo: nil, repeats: true)
        
        timer?.fire()
        
    }
    
    
    
    func updateProcessValue() {
        
        if vm == nil {
            
            return
        }
        
        if (vm?.isDeleted)! {
            
            timer?.invalidate()
            
            return
            
        }
        
        setText()
        
    }
    
    
    func setText() {
        
        txtProcessValue.text =  "(\((vm?.downloadedCount)!) / \((vm?.totalCount)!))"
        
        processView.progress =   vm?.processValue ?? 0
        
        if  vm?.processValue == 1 {
            
            txtProcessValue.text =  "下载完毕，数据处理中..."
            
        }
    }
    
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
        
        timer?.invalidate()
        
    }
    
    

    
    
    @IBAction func deleteAction() {
        
         vm?.delete()
        
    }
}


extension DownloadTableViewCell {
    
    
    func setupHighlightedBack() {
        
        btnDelete.backgroundColor = UIColor.clear
        btnDelete.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: UIControlState.normal)
        btnDelete.setBackgroundImage(UIImage.imageWithColor(color:  UIColor(red:19.0/255.0, green: 19.0/255.0, blue:19.0/255.0, alpha: 0.1)), for: UIControlState.highlighted)
        
    }
    
    
}







