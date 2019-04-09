//
//  DWZPictureView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/9.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZPictureView: UIView {

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
            addSubview(imageView)
        }
    }
}
