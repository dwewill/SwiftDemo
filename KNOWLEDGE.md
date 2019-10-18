# SwiftDemo KNOWLEDGE 知识点总结
// MARK: - 设置tabbar文字颜色的三种方式
--1.vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
UIColor.orange], for: .selected)
--2.tabBar.tintColor = UIColor.orange
--3.UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)

//MARK: - 可以写入文件到电脑
        (classArray as NSArray).write(toFile: "/Users/duanwenzheng/Desktop/class.plist", atomically: true)
        let data = try! JSONSerialization.data(withJSONObject: classArray, options: .prettyPrinted)
        (data as NSData).write(toFile: "/Users/duanwenzheng/Desktop/data.json", atomically: true)

//MARK: - throw 抛出异常
1. try? 可选try，成功有值，失败为nil 推荐
2. try!  强制try，成功有值，失败崩溃
3.  do catch操作，捕获异常，并处理
do {
    try操作
    } catch {
        error 异常
        print(error)
}M
s
//MARK: - Swift 4.0的变化
用字典转模型的时候，模型前要加上@objc 或者类前加上@ObjcMebers
原因：
@objcMembers 在Swift 4中继承 NSObject 的 swift class 不再默认全部 bridge 到 OC，如果我们想要使用的话我们就需要在class前面加上@objcMembers 这么一个关键字。
引用: 在 swift 3 中除了手动添加 @objc 声明函数支持 OC 调用还有另外一种方式：继承 NSObject。
class 继承了 NSObject 后，编译器就会默认给这个类中的所有函数都标记为 @objc ，支持 OC 调用。
苹果在Swift 4 中苹果修改了自动添加 @objc 的逻辑： 一个继承 NSObject 的 swift 类不再默认给所有函数添加 @objc。
只在实现 OC 接口和重写 OC 方法时才自动给函数添加 @objc 标识


// 代理


//MARK: -  图片裁剪
let image = UIImage(named: "")
let size = image?.size ?? CGSize.zero
//相当于图片内的那个点的水平、竖直线将图片裁剪成4块，分别是裁剪之后的对应四个角，中间的内容是那个分界点的一个像素填充颜色
let inset = UIEdgeInsets(top: size.height*0.5, left: size.width*0.5, bottom: size.height*0.5, right: size.width*0.5)
image = image?.resizableImage(withCapInsets: inset)
