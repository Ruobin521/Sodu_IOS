//
//  BookCatalogTableViewCell.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

class BookCatalogTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtIndex: UILabel!
    
    @IBOutlet weak var txtChapterName: UILabel!
    
    @IBOutlet weak var imageLocation: UIImageView!
    
    var bookCatalog:BookCatalog?  {
        
        didSet {
            
            if bookCatalog != nil {
                
                txtIndex.text = "\((bookCatalog?.chapterIndex)! + 1)."
                
                txtChapterName.text = bookCatalog?.chapterName
                
            }
            
            
        }
        
    }
    
 

    
}
