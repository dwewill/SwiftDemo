//
//  DWZTitleButton.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/6.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
 let isFirst = true

class DWZTitleButton: UIButton {
    private var isFirst = true
    init(text: String?) {
        super.init(frame: CGRect.zero)
        if text == nil {
            setTitle("首页", for: .normal)
        }else {
            setTitle(text!+" ", for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .selected)
        }
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(.darkGray, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // FIXME: - 为什么会调用两次
    // 重新布局label和imageView
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirst {
//            isFirst = false
        }else {
            return
        }
        guard let titleLabel = titleLabel,
        let imageView = imageView else {
            return
        }
        print("titleLabel:\(titleLabel) -- imageView:\(imageView)")
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        imageView.frame  = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        print("titleLabel:\(titleLabel) -- imageView:\(imageView)")
    }
}
