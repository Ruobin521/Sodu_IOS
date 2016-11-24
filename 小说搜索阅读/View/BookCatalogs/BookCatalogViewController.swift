//
//  BookCatalogViewController.swift
//  小说搜索阅读
//
//  Created by  ruobin on 2016/11/24.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class BookCatalogViewController: UIViewController {

    @IBOutlet weak var txtBookName: UILabel!
    
    @IBOutlet weak var btnScroll: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    
    @IBAction func closeAction() {
       
        dismiss(animated: true, completion: nil)
        
    }
    
    
    var catalogs:[BookCatalog]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
       setupUI()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
extension BookCatalogViewController:UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  catalogs?.count ??  0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookCatalogTableViewCell
        
        let catalog = catalogs?[indexPath.row]
        
        cell.bookCatalog = catalog?.clone() as! BookCatalog?
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let bookCatalog = tableview.cellfor
        
        tableview.deselectRow(at: indexPath, animated: true)
        
    }
    
}


extension BookCatalogViewController {
    
    
    func setupUI() {
        
        let cellNib = UINib(nibName: "BookshelfTableViewCell", bundle: nil)
        
        tableview.register(cellNib, forCellReuseIdentifier: cellId)
        
    }
    
    
}
