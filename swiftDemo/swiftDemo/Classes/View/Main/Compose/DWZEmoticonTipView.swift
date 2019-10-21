//
//  DWZEmoticonTipView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/21.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import pop

class DWZEmoticonTipView: UIImageView {
    
    /// 记录之前的表情数据
    var preEmoticon: DWZEmoticon?
    
    /// emoji数据，设置提示视图的内容
    var emoticon: DWZEmoticon? {
        didSet {
            if emoticon == preEmoticon {
                return
            }
            /// 更新记录模型
            preEmoticon = emoticon
            button.setImage(emoticon?.image, for: .normal)
            button.setTitle(emoticon?.emoji, for: .normal)
            
            /// 设置动画
            let ani: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            ani.fromValue = 40
            ani.toValue = 20
            ani.springBounciness = 20
            ani.springSpeed = 20
            button.layer.pop_add(ani, forKey: nil)
        }
    }
    // 私有属性，按钮
    private lazy var button = UIButton()
    
    init() {
        let bundle = DWZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        super.init(image: image)
        
        // 设置锚点，使得图片上移
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2);
        
        button.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        button.center.x = self.center.x
        button.setTitle("🤟", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
