//
//  DWZBaseViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
let screen = UIScreen.main
let screenWidth = screen.bounds.width
let screenHeight = screen.bounds.height
let scale = screen.scale
// 状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height
// 导航区域高度
let navigationBarHeight: CGFloat = 44
// 导航栏高度
let navigationHeight = statusBarHeight+navigationBarHeight
//@available(iOS 11.0, *)
//let navHeight = (UIApplication.shared.delegate?.window ?? UIWindow(frame: screen.bounds))?.safeAreaInsets.top ?? 0 > CGFloat(20) ? 88 : 64


class DWZBaseViewController: UIViewController {
    lazy var navBar = DWZNavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: navigationHeight))
    lazy var navBarItem = UINavigationItem()
    var tableView: UITableView?
    var refreshControl : DWZRefreshControl?
    // 上拉刷新标识
    var isPullUp = false
    // 用户登录标识
    var isLogon = true
    // 游客视图数据
    var visitorInfo: [String:String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
        DWZNetworkManager.shared.userLogon ? loadData() : ()
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLoginSuccess), name: NSNotification.Name(rawValue: DWZUserLoginSuccessNotification), object: nil)
    }
    
    override var title: String? {
        didSet {
            navBarItem.title = title
        }
    }
    
    @objc func loadData() {
        refreshControl?.endRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - 访客视图按钮事件监听
extension DWZBaseViewController {
    @objc private func userLoginSuccess(notification: Notification) {
        print(#function)
        navBarItem.leftBarButtonItem = nil
        navBarItem.rightBarButtonItem = nil
        // 会调用loadView -> viewDidLoad
        view = nil
        // MARK: - 通知是可以重复注册，会调用多次
        NotificationCenter.default.removeObserver(self)
    }

    
    @objc private func login() {
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name.init(DWZUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register() {
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name.init(DWZUserShouldRegisterNotification), object: nil)
    }
}

// MARK: - 搭建页面
extension DWZBaseViewController {
    @objc fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        DWZNetworkManager.shared.userLogon ? setupTableView() : setupVisiterView()
    }
    
    fileprivate func setupVisiterView() {
        let visiterView = DWZVisitorView(frame: view.bounds)
        view.insertSubview(visiterView, belowSubview: navBar)
        visiterView.visiterInfo = visitorInfo
        visiterView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visiterView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        navBarItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navBarItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    @objc func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: navBar)
        tableView?.delegate = self
        tableView?.dataSource = self
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView?.contentInset = UIEdgeInsets(top: navBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 0, right: 0)
        tableView?.scrollIndicatorInsets = tableView?.contentInset ?? UIEdgeInsets.zero
        refreshControl = DWZRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    fileprivate func setupNavigationBar() {
        view.addSubview(navBar)
        navBar.items = [navBarItem]
        // 设置导航条的整个背景颜色
        navBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        // 设置title字体颜色
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
            UIColor.darkGray]
        // 设置系统按钮文字渲染颜色
        navBar.tintColor = .orange
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DWZBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections-1
        if row < 0 || section < 0  {
            return
        }
        // 如果是最后一行，同时没有上拉刷新
        if tableView.numberOfRows(inSection: section) == row+1 && !isPullUp {
            isPullUp = true
            loadData()
        }
    }
}
