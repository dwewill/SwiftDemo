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
    ///   - isBack: 是否返回按钮，返回按钮添加箭头图片
    convenience init(title: String, fontSize:CGFloat = 16, action: AnyObject?, selector: Selector, isBack: Bool = false) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        if isBack {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        btn.addTarget(action, action: selector, for: .touchUpInside)
        self.init(customView: btn)
    }
}
