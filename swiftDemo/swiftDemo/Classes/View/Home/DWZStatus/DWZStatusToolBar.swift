//
//  DWZToolBar.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/9.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit


/// 微博底下的转发/评论/点赞工具栏
class DWZStatusToolBar: UIView {

    var statusViewModel: DWZStatusViewModel? {
        didSet {
            transmitButton.setTitle(statusViewModel?.repostStr, for: .normal)
            commentButton.setTitle(statusViewModel?.commentStr, for: .normal)
            likeButton.setTitle(statusViewModel?.likeStr, for: .normal)
        }
    }
    // 转发按钮
    lazy var transmitButton = UIButton()
    // 评论按钮
    lazy var commentButton = UIButton()
    // 点赞按钮
    lazy var likeButton = UIButton()
    // 分割线imageViewOne
    lazy var sperateImageViewOne = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
    // 分割线imageViewTwo
    lazy var sperateImageViewTwo = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DWZStatusToolBar {
    private func setupUI() {
        // "timeline_icon_retweet"
        setToolBarButton(text: "转发", imageString: "timeline_icon_retweet", button: transmitButton)
        setToolBarButton(text: "评论", imageString: "timeline_icon_comment", button: commentButton)
        setToolBarButton(text: "点赞", imageString: "timeline_icon_unlike",seletedImageString: "timeline_icon_like", button: likeButton)
        
        addSubview(transmitButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(sperateImageViewOne)
        addSubview(sperateImageViewTwo)
        
        transmitButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
        }
        commentButton.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(transmitButton)
            make.left.equalTo(transmitButton.snp_right)
        }
        likeButton.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(transmitButton)
            make.right.equalTo(self)
            make.left.equalTo(commentButton.snp_right)
        }
        sperateImageViewOne.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(2)
            make.centerX.equalTo(transmitButton.snp_right)
            make.centerY.equalTo(self)
        }
        sperateImageViewTwo.snp.makeConstraints { (make) in
            make.height.width.centerY.equalTo(sperateImageViewOne)
            make.centerX.equalTo(commentButton.snp_right)
        }
    }
    
    func setToolBarButton(text: String, imageString: String, seletedImageString: String? = nil, button: UIButton) {
        button.setTitle(text, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setImage(UIImage(named: imageString), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        guard let seletedImageString = seletedImageString else {
            return
        }
        button.setImage(UIImage(named: seletedImageString), for: .selected)
    }
}
