//
//  DWZRefreshView.swift
//  DWZRefreshControlDemo
//
//  Created by 段文拯 on 2019/8/22.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZRefreshView: UIView {

    /// 刷新视图的状态
    /*
     iOS 系统UIView的旋转动画
     1.默认顺时针
     2.就近原则
     3.想实现同方向旋转，Double.pi 减去一个很小的角度
     4.360度的旋转动画用核心动画 `CABaseAnimation`
     */
    var refreshState: DWZRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipLabel.text = "继续下拉..."
                tipIcon.isHidden = false
                indicator.stopAnimating()
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon.transform = .identity
                }
            case .Pulling:
                tipLabel.text = "放手刷新..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi-0.001))
                }
            case .WillRefresh:
                tipLabel.text = "正在刷新..."
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }
    /// 刷新箭头图片
    lazy var tipIcon = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    /// 刷新提示文字
    lazy var tipLabel = UILabel(frame: CGRect.zero)
    /// 菊花指示器
    lazy var indicator = UIActivityIndicatorView(frame: CGRect.zero)
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
}

extension DWZRefreshView {
    func setupUI() {
        indicator.hidesWhenStopped = true
        indicator.color = .orange
        
        addSubview(tipIcon)
        addSubview(tipLabel)
        addSubview(indicator)
        
        tipLabel.text = "刷新中。。。"
        tipIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        tipLabel.frame = CGRect(x: 40, y: 10, width: 120, height: 20)
        indicator.frame = tipIcon.frame
    }
}
