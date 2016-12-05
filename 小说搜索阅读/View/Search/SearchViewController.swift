//
//  SearchViewController.swift
//  小说搜索阅读
//
//  Created by Ruobin Dang on 16/11/20.
//  Copyright © 2016年 Ruobin Dang. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class SearchViewController: BaseViewController {
    
    lazy  var  searchView =  UISearchBar()
    
    let vm =  SearchPageViewModel()
    
    
    override func loadData() {
        
        guard  let text = searchView.text?.trimmingCharacters(in: [" "]) else {
            
            return
            
        }
        
        ToastView.instance.showLoadingView()
        
        vm.loadSearchData(text) { (isSuccess) in
            
            if isSuccess {
                
                self.tableview?.reloadData()
                
                
            }else {
                
                self.showToast(content: "暂无搜索结果", false)
            }
            
            super.endLoadData()
            
            DispatchQueue.main.async {
                
                ToastView.instance.closeLoadingWindos()
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        ToastView.instance.closeLoadingWindos()
    }
    
}

extension  SearchViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  vm.bookList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBookListTableViewCell
        
        
        let book = vm.bookList[indexPath.section]
        
        
        cell.txtBookName?.text = book.bookName
        cell.txtUpdateTime?.text = book.updateTime
        cell.txtUpdateChpterName?.text = book.chapterName
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview?.deselectRow(at: indexPath, animated: true)
        
        CommonPageViewModel.navigateToUpdateChapterPage(vm.bookList[indexPath.section], navigationController)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return  ViewModelInstance.instance.userLogon
    }
    
    
    override  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1  =  UITableViewRowAction(style: .normal, title: "添加至书架", handler: { (action, indexPath) in
            
            let book = self.vm.bookList[indexPath.section]
            
            CommonPageViewModel.AddBookToShelf(book: book)
            
            DispatchQueue.main.async {
                
                tableView.isEditing = false
                
            }
            
        })
        
        action1.backgroundColor = UIColor(red:0, green:122.0/255.0, blue:1.0, alpha: 0.5)
        
        return [action1]
        
    }
    
    
}


extension SearchViewController {
    
    override func setupUI() {
        
        setUpNavigationBar()
        setBackColor()
        setupTableview()
        
        setSearchBar()
        
        setupFailedView()
        
        // searchView.center.x = (tableview?.center.x)!
        
        let cellNib = UINib(nibName: "CommonBookListTableViewCell", bundle: nil)
        
        tableview?.register(cellNib, forCellReuseIdentifier: cellId)
        
        tableview?.separatorStyle = .none
        
        
        
        
    }
    
    func  setSearchBar()  {
        
        
        searchView.frame =  CGRect(x: 0, y: (tableview?.contentInset.top)!, width: UIScreen.main.bounds.width , height: 50)
        
        self.view.insertSubview(searchView, aboveSubview: tableview!)
        
        tableview?.contentInset = UIEdgeInsets(top:  (tableview?.contentInset.top)! + searchView.frame.height, left: 0, bottom: (tableview?.contentInset.bottom)! , right: 0)
        
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tableview?.scrollIndicatorInsets = tableview!.contentInset
        
        searchView.delegate = self
        
        searchView.placeholder = "请输入小说名或关键字，支持中文拼音搜索"
        
    
        searchView.becomeFirstResponder()
        
    }
    
    
}

extension SearchViewController:UISearchBarDelegate  {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchView.resignFirstResponder()
        
        loadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let txt  = searchText
        
        if (  txt ==  ""  && vm.bookList.count > 0) {
            
            vm.bookList.removeAll()
            
            self.tableview?.reloadData()
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //searchView.placeholder = ""
        
        searchView.setShowsCancelButton(true, animated: false)
        
        // searchView.placeholder = "请输入小说名或关键字，支持中文拼音搜索"
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
         searchView.setShowsCancelButton(false, animated: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchView.resignFirstResponder()
        
        searchView.setShowsCancelButton(false, animated: true)
        
    }
    
}

