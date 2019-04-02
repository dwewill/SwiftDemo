//
//  DWZMainViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.

import UIKit

class DWZMainViewController: UITabBarController {

    lazy var compostButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        setupComposeButton()
    }
    
    // 设置竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // 发布按钮的点击
    @objc fileprivate func composeButtonClick() {
        print("composeButtonClick")
        present(DWZBaseViewController(), animated: true, completion: nil)
    }
}


// MARK: - 页面搭建
extension DWZMainViewController {
    fileprivate func setupComposeButton() {
        tabBar.addSubview(compostButton!)
        let compostButtonWidth = tabBar.bounds.size.width / CGFloat(viewControllers?.count ?? 1) - 1
        compostButton?.frame = tabBar.bounds.insetBy(dx: compostButtonWidth*2, dy: 0)
        compostButton?.addTarget(self, action: #selector(composeButtonClick), for: .touchUpInside)
    }
    
    fileprivate func setupChildControllers() {
        let classArray = [
            ["clsName":"DWZHomeViewController","title":"首页","imageName":"home","visitorInfo":["imageName":"","title":"关注一些人，回这里看看有什么惊喜"]],
            ["clsName":"DWZMessageViewController","title":"消息","imageName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message","title":"登录后，别人评论你的微博、发给你的消息，都会在这里收到通知"]],
            ["clsName":"UIViewController"],
            ["clsName":"DWZDiscoverViewController","title":"发现","imageName":"discover","visitorInfo":["imageName":"visitordiscover_image_message","title":"登录后，最新、最热微博尽在掌握，不会再与时事潮流擦肩而过"]],
            ["clsName":"DWZProfileViewController","title":"我的","imageName":"profile","visitorInfo":["imageName":"visitordiscover_image_profile","title":"登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]],
        ]
        var mControllers = [UIViewController]()
        for dic in classArray {
            mControllers.append(createChildController(dic))
        }
        viewControllers = mControllers
    }
    
    fileprivate func createChildController(_ dict: [String:Any]) -> UIViewController {
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namesspace+"."+clsName) as? DWZBaseViewController.Type,
        let visitorInfo = dict["visitorInfo"] as? [String:String]
            else {
                return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        vc.visitorInfo = visitorInfo
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.orange], for: .selected)
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        let nav = DWZNavigationController(rootViewController:vc)
        return nav
    }
}
