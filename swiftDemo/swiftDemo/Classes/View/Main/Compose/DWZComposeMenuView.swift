//
//  DWZComposeMenuView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/23.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import pop

class DWZComposeMenuView: UIView {

    /// 菜单按钮信息
    let menuInfo = [
        ["image":"tabbar_compose_idea","text":"文字","clsName":"DWZComposeViewController"],
        ["image":"tabbar_compose_photo","text":"照片/视频"],
        ["image":"tabbar_compose_weibo","text":"长微博"],
        ["image":"tabbar_compose_lbs","text":"签到"],
        ["image":"tabbar_compose_review","text":"点评"],
        ["image":"tabbar_compose_more","text":"更多","actionName":"moreButtonClick"],
        ["image":"tabbar_compose_friend","text":"好友圈"],
        ["image":"tabbar_compose_wbcamera","text":"微博相机"],
        ["image":"tabbar_compose_music","text":"音乐"],
        ["image":"tabbar_compose_shooting","text":"拍摄"] ]
    
    /// 菜单视图
    var scrollView: UIScrollView = UIScrollView(frame: CGRect.zero)
    
    /// 底部的取消按钮
    var cancelButton: UIButton = UIButton(frame: .zero)
    
    /// 回滚到第一页的按钮
    var backButton = UIButton(frame: .zero)
    
    /// 选择菜单成功block
    var completionBlock: ((_ clsName: String?)->())?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 展示视图
    func show(completion: @escaping (_ clsName: String?)->()) {
        completionBlock = completion
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        vc.view.addSubview(self)
        composeMenuAnimation()
    }
}


// MARK: - 动画方法
extension DWZComposeMenuView {
    
    /// 视图透明度动画方法
    private func composeMenuAnimation() {
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = 0.5
        pop_add(animation, forKey: nil)
        buttonsSpringAnimation()
    }
    
    /// 隐藏视图的动画
    private func hideViewAlphaAnimation() {
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = 0.5
        pop_add(animation, forKey: nil)
        animation.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    /// 按钮的弹力动画
    private func buttonsSpringAnimation() {
        let onePageView = scrollView.subviews[0]
        for (i,btn) in onePageView.subviews.enumerated() {
            let springAni: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            springAni.fromValue = btn.center.y+300
            springAni.toValue = btn.center.y
            /// 弹力系数
            springAni.springBounciness = 8
            springAni.springSpeed = 8
            springAni.beginTime = CACurrentMediaTime()+CFTimeInterval(i)*0.025
            btn.pop_add(springAni, forKey: nil)
        }
    }
}


// MARK: - 交互方法
extension DWZComposeMenuView {
    /// 取消按钮被点击
    @objc func cancelButtonClick() {
        print("cancelButtonClick")
        let view = scrollView.subviews[Int(scrollView.contentOffset.x/screenWidth)]
        for (i,btn) in view.subviews.enumerated().reversed() {
            print(i)
            let springAni: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            springAni.fromValue = btn.center.y
            springAni.toValue = btn.center.y+500
            /// 弹力系数
            springAni.springBounciness = 8
            springAni.springSpeed = 8
            springAni.beginTime = CACurrentMediaTime()+CFTimeInterval(view.subviews.count-i)*0.025
            btn.pop_add(springAni, forKey: nil)
            if i == 0 {
                springAni.completionBlock = { _, _ in
                    self.hideViewAlphaAnimation()
                }
            }
        }
    }
    
    /// 左滚动按钮被点击
    @objc func backButtonClick() {
        print("backButtonClick")
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.cancelButton.frame = CGRect(x: screenWidth*0.5-15, y: 7, width: 30, height: 30)
            self.backButton.frame = CGRect(x: screenWidth*0.5-15, y: 7, width: 30, height: 30)
            self.backButton.alpha = 0
        }) { (_) in
            self.backButton.isHidden = true
        }
    }
    
    
    /// 更多按钮被点击
    @objc func moreButtonClick() {
        backButton.isHidden = false
        backButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
            self.cancelButton.frame = CGRect(x: screenWidth/3, y: 7, width: 30, height: 30)
            self.backButton.frame = CGRect(x: screenWidth/3*2, y: 7, width: 30, height: 30)
            self.backButton.alpha = 1.0
        }
    }
    
    /// 菜单按钮被点击
    @objc func menuButtonClick(sender: DWZComposeMenuButton) {
        print("menuButtonClick:\(sender.clsName)")
        guard let text = sender.btnInfo["text"] else {
            return
        }
                
        let view = scrollView.subviews[Int(scrollView.contentOffset.y/screenWidth)]
        for (i,btn) in view.subviews.enumerated() {
            let scale = btn == sender ? 1.5 : 0.2
            let value = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            let scaleAni = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let alphaAni = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAni?.toValue = 0.2
            alphaAni?.fromValue = 1.0
            alphaAni?.duration = 0.5
            scaleAni?.toValue = value
            scaleAni?.duration = 0.5
            btn.pop_add(scaleAni, forKey: nil)
            btn.pop_add(alphaAni, forKey: nil)
            
            if i == 0 {
                alphaAni?.completionBlock = { _, _ in
                    print("动画完成")
                    self.completionBlock?(sender.clsName)
                }
            }
        }
        
    }
}

// MARK: - UI
extension DWZComposeMenuView {
    private func setupUI() {
        backgroundColor = .clear
        let blurView = UIVisualEffectView(frame: UIScreen.main.bounds)
        let effect = UIBlurEffect(style: .extraLight)
        blurView.effect = effect
        addSubview(blurView)
        
        /// slogan图片
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "compose_slogan")
        imageView.frame = CGRect(x: screenWidth*0.5-77, y: 100, width: 154, height: 48)
        blurView.contentView.addSubview(imageView)
        
        let btnWidth = screenWidth/3
        scrollView.frame = CGRect(x: 0, y: screenHeight-btnWidth*2-40-60-44-safeAreaHeight, width: screenWidth, height: btnWidth*2+40)
        scrollView.contentSize = CGSize(width: screenWidth*2, height: btnWidth*2+40)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        blurView.contentView.addSubview(scrollView)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: btnWidth*2+40))
        scrollView.addSubview(view)
        let viewTwo = UIView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: btnWidth*2+40))
        scrollView.addSubview(viewTwo)
        for (i,menu) in menuInfo.enumerated() {
            if i > 5 {
                let index = i - 6
                let btn = DWZComposeMenuButton(frame: CGRect.zero, info: menu)
                btn.frame = CGRect(x: CGFloat(index%3)*btnWidth, y: CGFloat(index/3)*(btnWidth+20), width: btnWidth, height: btnWidth+20)
                btn.addTarget(self, action: #selector(menuButtonClick(sender:)), for: .touchUpInside)
                btn.clsName = menu["clsName"]
                viewTwo.addSubview(btn)
                continue
            }
            let btn = DWZComposeMenuButton(frame: CGRect.zero, info: menu)
            btn.frame = CGRect(x: CGFloat(i%3)*btnWidth, y: CGFloat(i/3)*(btnWidth+20), width: btnWidth, height: btnWidth+20)
            btn.addTarget(self, action: #selector(menuButtonClick), for: .touchUpInside)
            view.addSubview(btn)
            if let actionName = menu["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else {
                btn.addTarget(self, action: #selector(menuButtonClick(sender:)), for: .touchUpInside)
            }
            btn.clsName = menu["clsName"]
        }
        
        /// 换页以及返回按钮
        let controlBar = UIView(frame: CGRect(x: 0, y: screenHeight-44-safeAreaHeight, width: screenWidth, height: 44))
        
        cancelButton.setImage(UIImage(named: "tabbar_compose_background_icon_close"), for: .normal)
        cancelButton.frame = CGRect(x: screenWidth*0.5-15, y: 7, width: 30, height: 30)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        backButton.setImage(UIImage(named: "tabbar_compose_background_icon_return"), for: .normal)
        backButton.frame = CGRect(x: screenWidth*0.5-15, y: 7, width: 30, height: 30)
        backButton.isHidden = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        controlBar.addSubview(cancelButton)
        controlBar.addSubview(backButton)
        
        blurView.contentView.addSubview(controlBar)
    }
    
    
}
