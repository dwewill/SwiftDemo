//
//  DWZVisitorView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/2.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZVisitorView: UIView {
    // 访客视图字典数组（imageName和title）
    var visiterInfo: [String: String]? {
        didSet {
            guard let imageName = visiterInfo?["imageName"],
                  let title = visiterInfo?["title"] else {
                return
            }
            titleLabel.text = title
            if imageName == "" {
                setupAnimation()
                return
            }
            iconView.image = UIImage(named: imageName)
            houseView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    // 转轮视图
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // 遮罩视图
    private lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    // 小房子视图
    private lazy var houseView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house")) 
    // 说明文字
    private lazy var titleLabel: UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜", fontSize: 14, color: .darkGray)
    // 注册按钮
    private lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: .orange, highlightedColor: .black, backgroundImageName: "common_button_white_disable")
    // 登录按钮
    private lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: .darkGray, highlightedColor: .black, backgroundImageName: "common_button_white_disable")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 页面搭建
extension DWZVisitorView {
    
    /// 设置首页转轮动画
    fileprivate func setupAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.repeatCount = Float(Int.max)
        rotationAnimation.duration = 15
        rotationAnimation.toValue = 2.0 * Double.pi
        // 设置动画不停止（页面切换，home键），同加入的视图同生命周期
        rotationAnimation.isRemovedOnCompletion = false
        iconView.layer.add(rotationAnimation, forKey: nil)
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseView)
        addSubview(titleLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 取消autoresizing, 才能用autoLayout (纯代码默认autoresizing，xib默认autoLayout)
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.textAlignment = .center
        // 转轮
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        // 小房子
        addConstraint(NSLayoutConstraint(item: houseView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        // 文字视图
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: -80))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 60))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: -80))
        
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -60))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: registerButton, attribute: .width, multiplier: 1.0, constant: 0))
        
        // 遮罩视图(VFL语法)
        let viewDic = ["maskIconView":maskIconView,"registerButton":registerButton]
        let metricsInfo = ["spacing":20]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]", options: [], metrics: metricsInfo, views: viewDic))
        
    }
}
