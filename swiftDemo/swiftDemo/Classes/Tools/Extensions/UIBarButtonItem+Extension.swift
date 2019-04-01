//
//  UIBarButtonItem.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/1.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体，默认16号
    ///   - action: action
    ///   - selector: selector
    convenience init(title: String, fontSize:CGFloat = 16, action: AnyObject?, selector: Selector) {
        let btn: UIButton = UIButton.cz_textButton("好友", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(action, action: selector, for: .touchUpInside)
        self.init(customView: btn)
    }
}
