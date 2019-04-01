//
//  DWZBaseViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZBaseViewController: UIViewController {
    lazy var navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    lazy var navBarItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    override var title: String? {
        didSet {
            navBarItem.title = title
        }
    }
}

extension DWZBaseViewController {
    @objc func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        view.addSubview(navBar)
//        navBar.items = [navBarItem]
    }
}
