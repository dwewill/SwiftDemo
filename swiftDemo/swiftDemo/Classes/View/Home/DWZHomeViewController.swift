//
//  DWZHomeViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZHomeViewController: DWZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc fileprivate func showFriends() {
        print(#function)
        let vc = DWZTestViewController()
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DWZHomeViewController {
    override func setupUI() {
        super.setupUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}
