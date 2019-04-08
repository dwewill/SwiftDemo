//
//  DWZNewFeatureView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/7.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZNewFeatureView: UIView {
    lazy var scrollView = UIScrollView()
    lazy var enterButton = UIButton()
    lazy var pageControl = UIPageControl()
    let count = 4
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 页面交互
extension DWZNewFeatureView {
    @objc fileprivate func enterButtonClick() {
        self.removeFromSuperview()
    }
}

// MARK: - 页面搭建
extension DWZNewFeatureView {
    private func setupUI() {
        backgroundColor = .clear
        addSubview(scrollView)
        addSubview(enterButton)
        addSubview(pageControl)
        
        enterButton.setBackgroundImage(UIImage(named: "new_feature_finish_button"), for: .normal)
        enterButton.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), for: .highlighted)
        enterButton.setTitle("欢迎进入", for: .normal)
        
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .darkGray
        
        self.frame = screen.bounds
        scrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        enterButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(UIImage(named: "new_feature_finish_button")?.size ?? CGSize.zero)
            make.centerY.equalTo(self).offset(150)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(enterButton.snp_bottom).offset(20)
        }
        
        for i in 1..<(count+1) {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "new_feature_"+"\(i)")
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: screenWidth*CGFloat(i-1), y: 0, width: screenWidth, height: screenHeight)
        }
        pageControl.numberOfPages = count
        pageControl.isUserInteractionEnabled = false
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(count+1), height: screenHeight)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        enterButton.addTarget(self, action: #selector(enterButtonClick), for: .touchUpInside)
        enterButton.isHidden = true
    }
}

// MARK: - UIScrollViewDelegate
extension DWZNewFeatureView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        let page = Int((scrollView.contentOffset.x + screenWidth*0.5) / screenWidth)
        print(page)
        pageControl.currentPage = Int(page)
        pageControl.isHidden = (page == count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / screenWidth)
        // 滚动到最后一屏，视图删除
        if page == count {
            self.removeFromSuperview()
        }
        // 倒数第二屏才显示进入页面
        enterButton.isHidden = page != count-1
    }
}
