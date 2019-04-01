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
        // 该方法也可以隐藏底部tabbar但是要从每个从根控制器跳转都要设置
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DWZHomeViewController {
    override func setupUI() {
        super.setupUI()
//        let btn: UIButton = UIButton.cz_textButton("好友", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
//        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", action: self, selector: #selector(showFriends))
    }
}
