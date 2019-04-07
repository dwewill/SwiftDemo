//
//  DWZWelcomeView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/7.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import SnapKit

class DWZWelcomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DWZWelcomeView {
    private func setupUI() {
        backgroundColor = .brown
        
        let backgroundImageView = UIImageView(image: UIImage(named: "ad_background"))
        addSubview(backgroundImageView)
        
        let avatarImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        addSubview(avatarImageView)
        
        let textLabel = UILabel()
        textLabel.text = "欢迎回来"
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        self.frame = screen.bounds
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(85)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(60)
        }
        textLabel.snp.makeConstraints { (make) in
            make.width.left.equalTo(self)
            make.top.equalTo(avatarImageView.snp_bottom).offset(20)
            make.height.equalTo(20)
        }
    }
}
