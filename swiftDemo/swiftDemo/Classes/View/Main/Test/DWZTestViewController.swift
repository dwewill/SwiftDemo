//
//  DWZTestViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/1.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZTestViewController: DWZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第 \(navigationController?.viewControllers.count ?? 0) 个"
    }
    
    @objc fileprivate func showNext() {
        print(#function)
        let vc = DWZTestViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension DWZTestViewController {
    override func setupUI() {
        super.setupUI()
        navBarItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", action: self, selector: #selector(showNext))
    }
}
