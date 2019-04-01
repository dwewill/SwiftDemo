# SwiftDemo KNOWLEDGE 知识点总结
// MARK: - 设置tabbar文字颜色的三种方式
--1.vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
UIColor.orange], for: .selected)
--2.tabBar.tintColor = UIColor.orange
--3.UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)
