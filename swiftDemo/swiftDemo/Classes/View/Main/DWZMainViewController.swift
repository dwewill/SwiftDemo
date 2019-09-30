//
//  DWZMainViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.

import UIKit
import SVProgressHUD

class DWZMainViewController: UITabBarController {
    // 发布按钮
    lazy var compostButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    // 时钟计时器
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        setupComposeButton()
        setupTimer()
        setupNewFeatureView()
        delegate = self
        // 添加通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: DWZUserShouldLoginNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userRegister), name: NSNotification.Name(rawValue: DWZUserShouldRegisterNotification), object: nil)
    }
    
    // 设置竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // 发布按钮的点击
    @objc fileprivate func composeButtonClick() {
        print("composeButtonClick")
//        present(DWZBaseViewController(), animated: true, completion: nil)
        let composeMenuView = DWZComposeMenuView()
        composeMenuView.show { [weak composeMenuView] (clsName) in
            guard let clsName = clsName,
            let cls = NSClassFromString(Bundle.main.namesspace+"."+clsName) as? UIViewController.Type else {
                composeMenuView?.removeFromSuperview()
                return
            }
            let vc = cls.init()
            self.present(vc, animated: true, completion: {
                composeMenuView?.removeFromSuperview()
            })
        }
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - 新特性视图
extension DWZMainViewController {
    
    /// 设置新特性页面
    private func setupNewFeatureView() {
        if !DWZNetworkManager.shared.userLogon {
            return
        }
        let newFeatureView = isNewVersion ? DWZNewFeatureView(frame: CGRect.zero) : DWZWelcomeView(frame: CGRect.zero)
        view.addSubview(newFeatureView)
    }
    
    private var isNewVersion: Bool {
        // 取当前版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        // 取本地版本号
        let path = ("version" as NSString).cz_appendDocumentDir() ?? ""
        let localVersion = try? String(contentsOfFile: path, encoding: .utf8)
        
        //存入当前版本号
        _ =  try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        return currentVersion != localVersion
    }
}

// MARK: - 处理登录，注册通知
extension DWZMainViewController {
    @objc private func userLogin(notification: Notification) {
        print(#function)
        var when = DispatchTime.now()
        if notification.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "")
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let nav = UINavigationController(rootViewController: DWZOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc private func userRegister(notification: Notification) {
        print(#function)
    }
}

// MARK: - UITabBarControllerDelegate
extension DWZMainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let idx = (children as NSArray).index(of: viewController)
        if selectedIndex == 0 && idx == 0 {
            print("这个地方要重新请求数据")
            let nav = children.first as? DWZNavigationController
            let homeVC = nav?.viewControllers.first as? DWZHomeViewController
            // FIXME: - navigationBar的高度是固定值
            homeVC?.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                homeVC?.loadData()
            }
            homeVC?.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟相关方法
extension DWZMainViewController {
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(timerRepeatFunction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerRepeatFunction() {
        if !DWZNetworkManager.shared.userLogon {
            return
        }
        DWZNetworkManager.shared.unreadCount { (count) in
            print("未读消息数\(count)")
//            let homeNav = self.viewControllers?.first as? DWZNavigationController
//            let homeVC = homeNav?.viewControllers.first
//            homeVC?.tabBarItem.badgeValue = count > 0 ? "\(count)" : nil
            count > 0 ? self.tabBar.items?[0].badgeValue = "\(count)" : ()
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - 页面搭建
extension DWZMainViewController {
    fileprivate func setupComposeButton() {
        tabBar.addSubview(compostButton!)
        let compostButtonWidth = tabBar.bounds.size.width / CGFloat(children.count)
        compostButton?.frame = tabBar.bounds.insetBy(dx: compostButtonWidth*2, dy: 0)
        compostButton?.addTarget(self, action: #selector(composeButtonClick), for: .touchUpInside)
    }
    
    fileprivate func setupChildControllers() {
        let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = docDir.appendingFormat("main.json")
        var data = try? NSData(contentsOfFile: jsonPath, options: [])
        if data == nil {
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            data = try? NSData(contentsOfFile: path!, options: [])
        }
        guard let classArray = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:Any]]
        else {
            return
        }
        
        var mControllers = [UIViewController]()
        for dic in classArray ?? [] {
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
