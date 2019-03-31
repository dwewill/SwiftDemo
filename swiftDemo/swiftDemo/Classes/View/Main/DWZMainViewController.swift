//
//  DWZMainViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
    }

}


// MARK: - 页面搭建
extension DWZMainViewController {
    func setupChildControllers() {
        
        let classArray = [
            ["clsName":"DWZHomeViewController","title":"首页","imageName":"home"],
            ["clsName":"DWZMessageViewController","title":"消息","imageName":"message_center"],
            ["clsName":"DWZDiscoverViewController","title":"发现","imageName":"discover"],
            ["clsName":"DWZProfileViewController","title":"我的","imageName":"profile"],
        ]
        var mControllers = [UIViewController]()
        for dic in classArray {
            mControllers.append(createChildController(dic))
        }
        viewControllers = mControllers
    }
    
    func createChildController(_ dict: [String:String]) -> UIViewController {
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namesspace+"."+clsName) as? UIViewController.Type
            else {
                return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.orange], for: .selected)
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        let nav = DWZNavigationController(rootViewController:vc)
        return nav
    }
}
