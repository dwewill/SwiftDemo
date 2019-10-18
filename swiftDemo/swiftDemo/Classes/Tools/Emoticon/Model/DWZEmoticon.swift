//
//  DWZEmoticon.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/30.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

/// 表情模型
class DWZEmoticon: NSObject {
    /// 表情字符串，用于和服务器的数据传输，节约流量
    @objc var chs: String?
    
    /// 表情图片，用于本地图文混排
    @objc var png: String?
    
    /// 表情类型类型，默认是false，emoji是true
    @objc var type: Bool = false
    
    /// emoji
    @objc var emoji: String?
    
    /// emoji的s16进制编码
    @objc var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            guard let unicodeScalar = UnicodeScalar(result) else {
                return
            }
            emoji = String(Character(unicodeScalar))
        }
    }
    
    @objc var directory: String? {
        didSet {
            guard let directory = directory,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil) ,
            let bundle = Bundle(path: path),
            let png = png,
            let bundleImage = UIImage(named: directory+"/"+png, in: bundle, compatibleWith: nil) else {
                image = nil
                return
            }
            image = bundleImage
        }
    }
    
    
    /// 匹配图片文字
    ///
    /// - Parameter font: 字体大小
    /// - Returns: attributedString
    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        let attachment = DWZEmoticonAttahment()
        attachment.chs = chs
        attachment.image = image
        let height = font.lineHeight
        /// 调整图片位置
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        let attributed = NSMutableAttributedString(attachment: attachment)
        attributed.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributed.length))
        return attributed
    }
    
    /// 图片对象(也可以用计算属性,注释内容)
    @objc var image: UIImage?
//    {
//        if type {
//            return nil
//        }
//        guard let directory = directory,
//            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil) ,
//            let bundle = Bundle(path: path),
//            let png = png,
//            let bundleImage = UIImage(named: directory+"/"+png, in: bundle, compatibleWith: nil) else {
//                return nil
//        }
//        return bundleImage
//    }
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
