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
    
    
    var completionBlock: ((_ catalog:BookCatalog) -> ())?
    
    var book:Book?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        if  let name = book?.bookName {
            
            txtBookName.text = name
        }
        
        setupUI()
        
    }
    
}
extension BookCatalogViewController:UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  book?.catalogs?.count ??  0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookCatalogTableViewCell
        
        let catalog = book?.catalogs?[indexPath.row]
        
        cell.bookCatalog = catalog?.clone() as! BookCatalog?
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
                 
        guard  let catalog = book?.catalogs?[indexPath.row] else {
            
            return
        }
        
        completionBlock?(catalog)
        
        closeAction()
        
    }
    
    
    
}


extension BookCatalogViewController {
    
    
    func setupUI() {
        
        let cellNib = UINib(nibName: "BookCatalogTableViewCell", bundle: nil)
        
        tableview.register(cellNib, forCellReuseIdentifier: cellId)
        
        
        
    }
    
    
    func  setupTableHeaderView() {
        
        let v = BookIntroductionView.bookIntroductionView(bookName: book?.bookName, lywz: book?.lywzName, author: book?.author, introduction: book?.introduction)
        
        
        tableview.tableHeaderView = v
        
    }
    
    
}
