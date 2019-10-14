//
//  DWZEmoticonManager.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/30.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZEmoticonManager {

    /// 创建emotion管理单例
    static let shared = DWZEmoticonManager()
    
    /// 懒加载表情包数据
    lazy var packages = [DWZEmoticonPackage]()
    
    /// 加private 防止自动创建对象
    private init() {
        loadPackage()
    }
}


// MARK: - 字符串匹配等操作
extension DWZEmoticonManager {
    
    
    /// 目标字符串中的emoticon匹配并且替换
    ///
    /// - Parameters:
    ///   - string: 目标字符串
    ///   - font: 字符串字体
    /// - Returns: 带有emoticon富文本字符串
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: string)
        let pattern = "\\[.*?\\]"
        let regu = try? NSRegularExpression(pattern: pattern, options: [])
        let matchs = regu?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        guard let ms = matchs else {
            return attributed
        }
        for m in ms.reversed() {
            let r = m.range(at: 0)
            let sub = (string as NSString).substring(with: r)
            let em = DWZEmoticonManager.shared.matchStringWithEmotion(string: sub)
            let att = em?.imageText(font: font) ?? NSAttributedString(string: "")
            attributed.replaceCharacters(in: r, with: att)
            print(attributed)
        }
        /// 设置富文本字体属性，使得计算文字的宽高的时候使用这些属性，不然会出现宽高不对的问题
        attributed.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributed.length))
        return attributed
    }
    
    /// 匹配字符串对应的Emoticon
    ///
    /// - Parameter string: 字符串
    /// - Returns: emoticon对象
    func matchStringWithEmotion(string: String) -> DWZEmoticon? {
        for p in packages {
            /// 正常闭包的写法
//            let result = p.emoticons.filter { (em) -> Bool in
//                return em.chs == string
//            }
        
        /// 省略写法
        let result = p.emoticons.filter { $0.chs == string }

        if result.count == 1 {
            return result[0]
        }
            
        }
        return nil
    }
}

// MARK: - 加载bundle 文件数据
extension DWZEmoticonManager {
    private func loadPackage() {
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
              let bundle = Bundle(path: path),
              let filePath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: filePath) as? [[String:String]],
              let models = NSArray.yy_modelArray(with: DWZEmoticonPackage.self, json: array) as? [DWZEmoticonPackage] else {
                print("加载数据失败")
                return
        }
        packages += models

        print(packages)
    }
}
