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
        NotificationCenter.default.addObserver(self, selector: #selector(statusImageViewClick), name: NSNotification.Name(DWZStatusImageViewClickNotification), object: nil)
    }
    
    
    /// 收到微博图片点击通知调用的方法
    @objc func statusImageViewClick(notification: Notification) {
        guard let dic = notification.object as? [String: Any],
            let index = dic["selectIndex"],
            let urls = dic["urls"] as? [String],
            let imageViews = dic["imageViews"] as? [UIImageView] else {
                return
        }
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: index as! Int, urls: urls, parentImageViews: imageViews)
        present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func showFriends() {
        print(#function)
        let vc = DWZTestViewController()
        // 该方法也可以隐藏底部tabbar但是要从每个从根控制器跳转都要设置
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadData() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
            self.listViewModel.loadStatus(isPullUp: self.isPullUp) { (isSuccess, shouldRefresh) in
                self.isPullUp = false
                self.refreshControl?.endRefreshing()
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            }
        }

    }
}


// MARK: - 页面搭建
extension DWZHomeViewController {
    override func setupTableView() {
        super.setupTableView()
        navBarItem.leftBarButtonItem = UIBarButtonItem(title: "好友", action: self, selector: #selector(showFriends))
//        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 220
        tableView?.register(DWZStatusCell.self, forCellReuseIdentifier: baseCellId)
        setupNavigationTitle()
    }
    
    private func setupNavigationTitle() {
        let screen_name = DWZNetworkManager.shared.DWZUser.screen_name
        
        let btn = DWZTitleButton(text: screen_name)
        btn.addTarget(self, action: #selector(navigationTitleClick(btn:)), for: .touchUpInside)
        navBarItem.titleView = btn
        DispatchQueue.main.async {
            btn.isSelected = true
        }
        DispatchQueue.main.async {
            btn.isSelected = false
        }
    }
    
    @objc private func navigationTitleClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}


// MARK: - TableView dataSource && delegate
extension DWZHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: baseCellId, for: indexPath) as! DWZStatusCell
        // 离屏渲染 - 异步绘制(用性能消耗换取体验优化)
        cell.layer.drawsAsynchronously = true
        // 栅格化(将cell的内容绘制成一个图显示)
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        // 设置cell代理
        cell.delegate = self
        
        cell.statusViewModel = listViewModel.statusList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.statusList[indexPath.row].rowHeight
    }
}


extension DWZHomeViewController: DWZStatusCellDelegate {
    func statusCellDidSelectedURLString(cell: DWZStatusCell, urlString: String) {
        print("---------\(urlString)--------")
        let vc = DWZWebViewController()
        vc.url = urlString
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
