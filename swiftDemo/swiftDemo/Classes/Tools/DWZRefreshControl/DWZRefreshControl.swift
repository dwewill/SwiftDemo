//
//  DWZRefreshControl.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/8/16.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

/// 刷新状态切换的临界值
private let DWZRefreshOffset: CGFloat = 60


/// 刷新状态
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum DWZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class DWZRefreshControl: UIControl {

    /// RefreshControl的父视图
    private weak var scrollView: UIScrollView?
    
    /// RefreshView刷新视图
    private lazy var refreshView: DWZRefreshView = DWZRefreshView()
    
    /// 构造函数
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        print(sv)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        /// 上推的时候不更新frame
        if height < 0 {
            return
        }
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        if sv.isDragging {
            if (height > DWZRefreshOffset && refreshView.refreshState == .Normal) {
                refreshView.refreshState = .Pulling
                print("放手刷新")
            }else if (height <= DWZRefreshOffset && refreshView.refreshState == .Pulling) {
                refreshView.refreshState = .Normal
                print("继续拉...")
            }
        }else {
            // 放手
            if refreshView.refreshState == .Pulling {
                /// 刷新完之后，状态置为Normal
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
        print(height)
    }
    
    override func removeFromSuperview() {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    open func beginRefreshing() {
        print("开始刷新")
        guard let sv = scrollView else {
            return
        }
        // 判断是否重复刷新，如果是，直接返回
        if refreshView.refreshState == .WillRefresh  {
            return
        }
        refreshView.refreshState = .WillRefresh
        var contentInset = sv.contentInset
        contentInset.top += DWZRefreshOffset
        sv.contentInset = contentInset
    }
    
    func endRefreshing() {
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        // 判断是否正在刷新，如果不是，直接返回。
        if refreshView.refreshState != .WillRefresh  {
            return
        }
        refreshView.refreshState = .Normal
        var contentInset = sv.contentInset
        contentInset.top -= DWZRefreshOffset
        sv.contentInset = contentInset
    }

}

extension DWZRefreshControl {
    func setupUI() {
        refreshView.backgroundColor = scrollView?.backgroundColor
        /// 设置超出边界不显示
//        clipsToBounds = true
        
        addSubview(refreshView)
        /// 自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
    }
}
