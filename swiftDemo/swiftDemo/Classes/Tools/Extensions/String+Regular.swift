//
//  String+Regular.swift
//  RegxDemo
//
//  Created by 段文拯 on 2019/9/29.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation
// <a href="http://app.weibo.com/t/feed/3auC5p" rel="nofollow">皮皮时光机</a>
// MARK: - 正则表达式
extension String {
    func firstMatch() -> (ref: String, source: String)? {
        let pattern = "<a href=\"(.*?)\" rel=\".*?\">(.*?)</a>"
        guard let regu = try? NSRegularExpression(pattern: pattern, options: []),
        let result = regu.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) else {
            print("创建失败或者不匹配")
            return nil
        }
        let ref = (self as NSString).substring(with: result.range(at: 1))
        let source = (self as NSString).substring(with: result.range(at: 2))
        return (ref,source)    }
}
