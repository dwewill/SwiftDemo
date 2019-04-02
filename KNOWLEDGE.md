# SwiftDemo KNOWLEDGE 知识点总结
// MARK: - 设置tabbar文字颜色的三种方式
--1.vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
UIColor.orange], for: .selected)
--2.tabBar.tintColor = UIColor.orange
--3.UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)

//MARK: - 该方法可以写入文件到电脑
        (classArray as NSArray).write(toFile: "/Users/duanwenzheng/Desktop/class.plist", atomically: true)
        let data = try! JSONSerialization.data(withJSONObject: classArray, options: .prettyPrinted)
        (data as NSData).write(toFile: "/Users/duanwenzheng/Desktop/data.json", atomically: true)

