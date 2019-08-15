//
//  DWZStatusRetweetView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/9.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZStatusRetweetView: UIView {

    var status: DWZStatus? {
        didSet {
            pictureView.pic_urls = status?.pic_urls
        }
    }
    
    var retweetStatusText: String? {
        didSet {
            originNormalLabel.text = retweetStatusText
        }
    }
    // 原创正文文字
    lazy var originNormalLabel = UILabel()
    // 图片区
    lazy var pictureView = DWZPictureView()
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DWZStatusRetweetView {
    fileprivate func setupUI() {
        backgroundColor = .lightGray
        addSubview(originNormalLabel)
        addSubview(pictureView)
        
        originNormalLabel.numberOfLines = 0
        originNormalLabel.textColor = .darkGray
        originNormalLabel.lineBreakMode = .byWordWrapping
        originNormalLabel.font = UIFont.systemFont(ofSize: 15)
        
        originNormalLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(originNormalLabel.snp_bottom)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(self)
        }
    }
}
