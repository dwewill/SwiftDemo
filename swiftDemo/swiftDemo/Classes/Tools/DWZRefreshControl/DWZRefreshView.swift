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
                tipLabel?.text = "继续下拉..."
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = .identity
                }
            case .Pulling:
                tipLabel?.text = "放手刷新..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi-0.001))
                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新..."
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    /// 父视图的高度，用来计算缩放比例
    var parentViewHeight: CGFloat = 0.0
    /// 刷新箭头图片
    var tipIcon: UIImageView?
    /// 刷新提示文字
    var tipLabel: UILabel?
    /// 菊花指示器
    var indicator: UIActivityIndicatorView?
    
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
    @objc func setupUI() {
        tipIcon = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
        tipLabel = UILabel(frame: CGRect.zero)
        indicator = UIActivityIndicatorView(frame: CGRect.zero)
        indicator?.hidesWhenStopped = true
        indicator?.color = .orange
        
        guard let tipIcon = tipIcon,
            let tipLabel = tipLabel,
            let indicator = indicator else  {
                return
        }
        addSubview(tipIcon)
        addSubview(tipLabel)
        addSubview(indicator)
        
        tipLabel.text = "刷新中。。。"
        tipIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        tipLabel.frame = CGRect(x: 40, y: 10, width: 120, height: 20)
        indicator.frame = tipIcon.frame
    }
}
