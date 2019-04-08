//
//  UIImageView+SDWebImage.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

extension UIImageView {
    func wz_setImage(urlString: String?, placeholderImage: UIImage?) {
        guard let urlString = urlString,
        let url = URL(string: urlString) else {
            print("urlString为空或者生成URL失败")
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, _, _, _) in
            
        }
    }
}
