//
//  DWZComposeInputToolBar.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/16.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

/// DWZComposeInputToolBar代理
@objc protocol DWZComposeInputToolBarDelegate: NSObjectProtocol {
    @objc optional func emojiKeyboardToolBarClick(composeInputToolBar: DWZComposeInputToolBar, index: Int)
}

class DWZComposeInputToolBar: UIView {
    
    /// 代理
    weak var delegate: DWZComposeInputToolBarDelegate?
    
    /// 当前选择索引
    var currentSelectdIndex: Int = 0 {
        didSet {
            for btn in subviews as? [UIButton] ?? [] {
                btn.isSelected = false
            }
            (subviews[currentSelectdIndex] as? UIButton)?.isSelected = true
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 交互方法
extension DWZComposeInputToolBar {
    
    /// 按钮被点击的方法
    ///
    /// - Parameter sender: 点击的按钮
    @objc func buttonClick(sender: UIButton) {
//        print(sender.tag)
        delegate?.emojiKeyboardToolBarClick?(composeInputToolBar: self, index: sender.tag)
    }
}

// MARK: - UI
extension DWZComposeInputToolBar {
    func setupUI() {
        backgroundColor = .white
        let btnWidth: CGFloat = 60
        let btnHeight: CGFloat = 30
        let widthMargin = (screenWidth - CGFloat(4)*btnWidth)/5
        for (i,group) in DWZEmoticonManager.shared.packages.enumerated() {
            let btn = UIButton()
            btn.setTitle(group.groupName, for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.setTitleColor(.orange, for: .selected)
            btn.tag = i
            btn.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
//            var image = UIImage(named: "")
//            let size = image?.size ?? CGSize.zero
//            let inset = UIEdgeInsets(top: size.height*0.5, left: size.width*0.5, bottom: size.height*0.5, right: size.width*0.5)
//            image = image?.resizableImage(withCapInsets: inset)
            btn.frame = CGRect(x: widthMargin+CGFloat(i)*(btnWidth+widthMargin), y: 5, width: btnWidth, height: btnHeight)
            addSubview(btn)
            if i == 0 {
                btn.isSelected = true
            }
        }
    }
}
