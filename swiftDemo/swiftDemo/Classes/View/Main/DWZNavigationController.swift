//
//  DWZNavigationController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 所有的push操作都是在这个方法完成的，初始化navgation的时候也会调用这个方法,通过子控制器数判断是否根控制器
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if let vc = viewController as? DWZBaseViewController {
                var backTitle = "返回"
                
                if children.count == 1 {
                    backTitle = children.first?.title ?? "返回"
                }
                vc.navBarItem.leftBarButtonItem = UIBarButtonItem(title: backTitle, action: self, selector: #selector(goBack), isBack: true)
            }
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func goBack() {
        print(#function)
        popViewController(animated: true)
    }
}
