//
//  LocalBookTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2017/1/11.
//  Copyright © 2017年 Ruobin Dang. All rights reserved.
//

import UIKit

class LocalBookTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var txtNewChapterName: UILabel!
    
    @IBOutlet weak var txtLastReadChapterName: UILabel!
    
    @IBOutlet weak var txtUpdateCount: UILabel!
    
    var vm:LocalBookItemViewModel? {
        
        didSet {
            
            vm?.checkUpdateCompletion = { (count:Int) in
                
                DispatchQueue.main.async {
                    
                    self.txtUpdateCount.text = String(count)
                }
                
            }
            
            
            vm?.updateCompletion = {
                
                DispatchQueue.main.async {
                    
                    self.txtUpdateCount.text = ""
                    
                    self.txtNewChapterName.text = self.vm?.book.chapterName
                  
                }
                
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
}
