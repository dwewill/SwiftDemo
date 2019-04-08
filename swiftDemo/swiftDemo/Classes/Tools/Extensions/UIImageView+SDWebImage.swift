//
//  UIImageView+SDWebImage.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 隔离SDWebImage，设置网络图片
    ///
    /// - Parameters:
    ///   - urlString: 图片urlString
    ///   - placeholderImage: 占位图片
    ///   - isAvatar: 是否头像
    func wz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
        let url = URL(string: urlString) else {
            print("urlString为空或者生成URL失败")
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _) in
            if isAvatar {
                self?.image = image?.wz_avatarImage(size: self?.bounds.size)
            }
        }
    }
}
