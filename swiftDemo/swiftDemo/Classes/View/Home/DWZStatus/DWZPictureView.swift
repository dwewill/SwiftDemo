//
//  DWZPictureView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/9.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZPictureView: UIView {
    
    var viewModel: DWZStatusViewModel? {
        didSet {
            calculateViewSize()
        }
    }

    //根据视图模型的配图视图大小，调整显示内容
    func calculateViewSize() {
        // 单图
        if viewModel?.picURLs?.count == 1 {
            // 设置单图的的size
        }else {
            // 回复第一张图的size
        }
        if let count = viewModel?.status.pic_urls?.count,
            count > 0 {
            self.snp.updateConstraints { (make) in
                make.width.equalTo(viewModel?.pictureViewSize?.width ?? 0)
                make.height.equalTo(viewModel?.pictureViewSize?.height ?? 0)
            }
        }else {
            self.snp.updateConstraints { (make) in
                make.width.equalTo( 0)
                make.height.equalTo(0)
            }
        }
        
    }
    
    
    /// 点击图片触发的方法
    ///
    /// - Parameter tap: 触发事件
    @objc func imageViewClick(tap: UITapGestureRecognizer) {
        guard let imageView = tap.view,
            let urls = (pic_urls as NSArray?)?.value(forKeyPath: "thumbnail_pic") as? [String] else {
            return
        }
        
        // 判断四张图的索引大于1的情况
        var selectIndex = imageView.tag
        if urls.count == 4 && selectIndex > 1 {
            selectIndex -= 1
        }
        
        var imageViews: [UIImageView] = [UIImageView]()
        
        for iv in subviews as? [UIImageView] ?? [] {
            if !iv.isHidden {
                imageViews.append(iv)
            }
        }
        
        let dic: [String: Any] = ["selectIndex": selectIndex,
                   "urls":urls,
                   "imageViews":imageViews]
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(DWZStatusImageViewClickNotification), object: dic)
    }
    
    var pic_urls: [DWZStatusPicture]? {
        didSet {
            for view in subviews {
                view.isHidden = true
            }
            guard let pic_urls = pic_urls else{
                return
            }
            let count = pic_urls.count
            var i = 0
            for j in 0..<count {
                if count == 4 && i == 2 {
                    i += 1
                }
                let imageView = subviews[i] as! UIImageView
                imageView.isHidden = false
                imageView.wz_setImage(urlString: pic_urls[j].thumbnail_pic, placeholderImage: nil)
                i += 1
            }
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

extension DWZPictureView {
    private func setupUI() {
        let pictureHeight = (screenWidth - 2*12 - 2*3)/3
        for i in 0..<9 {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(Int(i%3))*(pictureHeight+DWZStatusPictureInnerMargin), y: CGFloat(Int(i/3))*(pictureHeight+DWZStatusPictureInnerMargin)+DWZStatusPictureOutterMargin, width: pictureHeight, height: pictureHeight))
            imageView.tag = i
            addSubview(imageView)
            
            imageView.isUserInteractionEnabled = true
            /// 增加手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewClick(tap:)))
            imageView.addGestureRecognizer(tap)
        }
    }
}
