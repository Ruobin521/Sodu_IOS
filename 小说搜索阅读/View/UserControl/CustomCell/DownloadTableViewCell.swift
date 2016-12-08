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
        
        txtProcessValue.text =  "(\((vm?.downloadedCount)!) / \((vm?.totalCount)!))"
        
        processView.progress =  Float((vm?.downloadedCount)!) / Float((vm?.totalCount)!)
        
        if (vm?.isCompleted)! {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RemoveDownloadItemNotification), object: vm?.book?.bookId)
 
        }
        
    }
    
      
}
