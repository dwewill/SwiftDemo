//
//  DWZMTRefreshView.swift
//  DWZRefreshControlDemo
//
//  Created by 段文拯 on 2019/9/19.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZMTRefreshView: DWZRefreshView {

    /// 城市图片
    var buildingIcon = UIImageView(frame: .zero)
    /// 袋鼠图片
    var kangarooIcon = UIImageView(frame: .zero)
    /// 地图图片
    var earthIcon = UIImageView(frame: .zero)
    
    override var parentViewHeight: CGFloat {
        didSet {
            if parentViewHeight < 23 {
                return
            }
            var scale: CGFloat
            if parentViewHeight >= 126 {
                scale = 1
            }else {
                scale = (parentViewHeight-23)/(126-23)*0.8+0.2
            }
            
            kangarooIcon.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}


extension DWZMTRefreshView {
    override func setupUI() {
        backgroundColor = .brown
        clipsToBounds = true
      guard  let building1 = UIImage(named: "icon_building_loading_1"),
        let building2 = UIImage(named: "icon_building_loading_2"),
        let kangaroo1 = UIImage(named: "icon_small_kangaroo_loading_1"),
        let kangaroo2 = UIImage(named: "icon_small_kangaroo_loading_2") else {
            return
        }

        /// 设置UIImageView的动画
        buildingIcon.image = UIImage.animatedImage(with: [building1,building2], duration: 0.5)
        kangarooIcon.image = UIImage.animatedImage(with: [kangaroo1,kangaroo2], duration: 0.5)
        earthIcon.image = UIImage(named: "icon_earth")
        
        addSubview(buildingIcon)
        addSubview(earthIcon)
        addSubview(kangarooIcon)
        
        buildingIcon.frame = CGRect(x: UIScreen.main.bounds.width*0.5-60, y: 0, width: 120, height: 120)
        kangarooIcon.frame = CGRect(x: UIScreen.main.bounds.width*0.5-40, y: 23, width: 80, height: 80)
        earthIcon.frame = CGRect(x: UIScreen.main.bounds.width*0.5-120, y: 100, width: 240, height: 240)
        
        /// 设置基础动画
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        baseAnimation.toValue = -2*Double.pi
        baseAnimation.repeatCount = Float(Int.max)
        baseAnimation.duration = 3.0
        baseAnimation.isRemovedOnCompletion = false
        earthIcon.layer.add(baseAnimation, forKey: nil)
        
        /// 设置图片的缩放，锚点要配合frame使用
        kangarooIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        kangarooIcon.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: 100)
        kangarooIcon.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
}
