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
    
    var vm:DownLoadItemViewModel? {
        
        didSet {
            
            txtBookName.text = vm?.book?.bookName
            
            setText() 

        }
        
    }
    
    
    var timer:Timer?
    
    
    override func awakeFromNib() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProcessValue), userInfo: nil, repeats: true)
        
        timer?.fire()

    }
    
    
    
    func updateProcessValue() {
        
        if vm == nil {
            
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
    
      
}
