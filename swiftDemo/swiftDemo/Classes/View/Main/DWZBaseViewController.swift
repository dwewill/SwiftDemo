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
// FIXME: - iPhone X/XS/XR/XSMAX 适配
//@available(iOS 11.0, *)
//let navHeight = (UIApplication.shared.delegate?.window ?? UIWindow(frame: screen.bounds))?.safeAreaInsets.top ?? 0 > CGFloat(20) ? 88 : 64


class DWZBaseViewController: UIViewController {
    lazy var navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
    lazy var navBarItem = UINavigationItem()
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
        loadData()
    }
    
    override var title: String? {
        didSet {
            navBarItem.title = title
        }
    }
    
    func loadData() {
    
    }
}


// MARK: - 搭建页面
extension DWZBaseViewController {
    @objc func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        setupNavigationBar()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
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
        tableView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        tableView?.scrollIndicatorInsets = tableView?.contentInset ?? UIEdgeInsets.zero
    }
    
    fileprivate func setupNavigationBar() {
        view.addSubview(navBar)
        navBar.items = [navBarItem]
        navBar.tintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
            UIColor.darkGray]
        navBar.backgroundColor = UIColor.cz_color(withHex: 0xF6F6F6)
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
}
