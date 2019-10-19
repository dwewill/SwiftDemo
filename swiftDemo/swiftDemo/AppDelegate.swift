//
//  AppDelegate.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = DWZMainViewController()
        window?.makeKeyAndVisible()
        
        setupAdditions()
        loadAppInfo()
        loadLocalData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// APP的额外信息
extension AppDelegate {
    private func setupAdditions() {
        // SVP的最小显示时间
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        // AFN的指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        // 通知的授权
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert,.carPlay]) { (result, error) in
                print("通知授权结果\(result)")
            }
        } else {
            // iOS8以后设置app角标要先注册设置
            let settings = UIUserNotificationSettings(types: [.badge,.sound,.alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}

// 加载APP的配置
extension AppDelegate {
    private func loadAppInfo() {
        DispatchQueue.main.async {
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            let data = NSData(contentsOfFile: path!)
            // 数据存入沙盒
            let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = docDir.appendingFormat("main.json")
            let res = data?.write(toFile: jsonPath, atomically: true)
            guard let result = res else {
                print("没有获取到写入结果")
                return
            }
            result ? print("写入成功") : print("写入失败")
        }
    }
    
    /// 异步加载表情包数据
    private func loadLocalData() {
//        DispatchQueue.main.async {
//            let _ = DWZEmoticonManager.shared
//        }
        DispatchQueue.global().async {
            let _ = DWZEmoticonManager.shared
        }
    }
}

