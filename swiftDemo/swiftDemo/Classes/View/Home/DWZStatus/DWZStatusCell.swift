//
//  DWZStatusCell.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZStatusCell: UITableViewCell {
    // 视图模型
    var statusViewModel: DWZStatusViewModel? {
        didSet {
            avatarImageView.wz_setImage(urlString: statusViewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            verifiedTypeImageView.image = statusViewModel?.verifyIcon
            leverImageView.image = statusViewModel?.memberIcon
            nameLabel.text = statusViewModel?.status.user?.screen_name
            timeLabel.text = statusViewModel?.status.created_at
//            sourceLabel.text = statusViewModel?.status.source
            sourceLabel.text = "\(statusViewModel?.status.pic_urls?.count ?? 0)"
            normalTextLabel.text = statusViewModel?.status.text
            statusToolBar.statusViewModel = statusViewModel
            guard let pictureViewSize = statusViewModel?.pictureViewSize else {
                return
            }
            pictureView.snp.updateConstraints { (make) in
                make.width.equalTo(pictureViewSize.width)
                make.height.equalTo(pictureViewSize.height)
            }
            pictureView.pic_urls = statusViewModel?.status.pic_urls
        }
    }

    
    // 顶部灰色部分
    lazy var grayView = UIView()
    // 头像
    lazy var avatarImageView = UIImageView()
    // 身份标识（头像的右下角）
    lazy var verifiedTypeImageView = UIImageView()
    // 用户昵称
    lazy var nameLabel = UILabel()
    // 用户等级头像
    lazy var leverImageView = UIImageView()
    // 发布时间
    lazy var timeLabel = UILabel()
    // 来源
    lazy var sourceLabel = UILabel()
    // 正文
    lazy var normalTextLabel = UILabel()
    // 图片区
    lazy var pictureView = DWZPictureView()
    // 工具栏
    lazy var statusToolBar = DWZStatusToolBar()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 页面搭建
extension DWZStatusCell {
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(grayView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(verifiedTypeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(leverImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(normalTextLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(statusToolBar)
        
        grayView.backgroundColor = UIColor.cz_color(withHex: 0xf2f2f2)
        
        verifiedTypeImageView.image = UIImage(named: "avatar_vip")
        
        nameLabel.textColor = UIColor.cz_color(withHex: 0xf33e00)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        
        leverImageView.image = UIImage(named: "common_icon_membership")
        
        timeLabel.textColor = UIColor.cz_color(withHex: 0x828282)
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        
        sourceLabel.textColor = UIColor.cz_color(withHex: 0xff6c00)
        sourceLabel.font = UIFont.systemFont(ofSize: 11)
        
        normalTextLabel.numberOfLines = 0
        normalTextLabel.textColor = .darkGray
        normalTextLabel.font = UIFont.systemFont(ofSize: 15)
        
        grayView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(8)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(grayView.snp_bottom).offset(7)
            make.left.equalTo(contentView).offset(12)
            make.width.height.equalTo(34)
        }
        
        verifiedTypeImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarImageView.snp_right).offset(-4)
            make.centerY.equalTo(avatarImageView.snp_bottom).offset(-4)
            make.width.height.equalTo(14)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView).offset(4)
            make.left.equalTo(avatarImageView.snp_right).offset(11)
            make.height.equalTo(13)
        }
        
        leverImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(3)
            make.height.width.equalTo(14)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(4)
            make.left.equalTo(nameLabel)
            make.height.equalTo(12)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp_right).offset(6)
            make.height.equalTo(12)
        }
        
        normalTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView)
            make.right.equalTo(contentView).offset(-12)
            make.top.equalTo(avatarImageView.snp_bottom).offset(12)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(normalTextLabel.snp_bottom)
            make.left.equalTo(contentView).offset(12)
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
        
        statusToolBar.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(pictureView.snp_bottom).offset(12)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView).offset(-5)
        }
    }
}
