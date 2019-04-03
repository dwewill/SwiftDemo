//
//  DWZHomeViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
private let baseCellId = "baseCellId"

class DWZHomeViewController: DWZBaseViewController {

    private lazy var listViewModel = DWZStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc fileprivate func showFriends() {
        print(#function)
        let vc = DWZTestViewController()
        // 该方法也可以隐藏底部tabbar但是要从每个从根控制器跳转都要设置
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadData() {
//        listViewModel.loadStatus { (isSuccess) in
//            self.isPullUp = false
//            self.refreshControl?.endRefreshing()
//            self.tableView?.reloadData()
//        }
//        listViewModel.
    }
}


// MARK: - 页面搭建
extension DWZHomeViewController {
    override func setupTableView() {
        super.setupTableView()
        navBarItem.leftBarButtonItem = UIBarButtonItem(title: "好友", action: self, selector: #selector(showFriends))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: baseCellId)
    }
}


// MARK: - TableView dataSource && delegate
extension DWZHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: baseCellId, for: indexPath)
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text ?? "\(indexPath.row)"
        return cell
    }
}
