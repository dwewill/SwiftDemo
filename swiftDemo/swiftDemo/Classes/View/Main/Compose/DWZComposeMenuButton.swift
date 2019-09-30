//
//  DWZComposeMenuButton.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/24.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZComposeMenuButton: UIControl {
    // 创建按钮的数据(图片和文字)
    var btnInfo: [String: String]
    var clsName: String?
     init(frame: CGRect, info: [String: String]) {
        self.btnInfo = info
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DWZComposeMenuButton {
    private func setupUI() {
        let imageView = UIImageView(frame: CGRect.zero)
        let titleLabel = UILabel(frame: CGRect.zero)
        addSubview(imageView)
        addSubview(titleLabel)
        let btnWidth = screenWidth/3
        imageView.frame = CGRect(x: 10, y: 10, width: btnWidth-20, height: btnWidth-20)
        titleLabel.frame = CGRect(x: 0, y: btnWidth, width: btnWidth, height: 20)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .orange
        
        imageView.image = UIImage(named: btnInfo["image"] ?? "")
        titleLabel.text = btnInfo["text"]

    }
}
