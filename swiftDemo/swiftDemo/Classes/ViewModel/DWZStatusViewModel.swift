//
//  DWZStatusViewModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZStatusViewModel: CustomStringConvertible {
    
    // 微博模型
    var status: DWZStatus
    
    // 会员图标 (用存储属性优于计算属性，复用的时候不用重复计算)
    var memberIcon: UIImage?
    
    // 认证图标
    var verifyIcon: UIImage?
    
    // 转发数文字
    var repostStr: String?
    
    // 评论数文字
    var commentStr: String?
    // 点赞数文字
    var likeStr: String?
    
    // 配图视图的大小
    var pictureViewSize: CGSize?
    
    // 转发微博的文字
    var retweetStatusText: String?
    
    // 转发微博的高度
    var retweetViewHeight: CGFloat?
    
    init(status: DWZStatus) {
        self.status = status
        
        // 计算星标等级图片
        if let mbarank = status.user?.mbrank {
            if mbarank > 0 && mbarank < 7 {
                memberIcon = UIImage(named: "common_icon_membership_level\(mbarank)")
            }
        }
        
        // 计算认证类型图片
//        if let verified_type = status.user?.verified_type {
//            // 认证类型 -1：没有认证， 0 认证用户，2、3、5企业认证， 220：达人
//            if verified_type == 0 {
//                verifyIcon = UIImage(named: "avatar_vip")
//            }else if verified_type == 2 || verified_type == 3 || verified_type == 5 {
//                verifyIcon = UIImage(named: "avatar_enterprise_vip")
//            }else if verified_type == 220 {
//                verifyIcon = UIImage(named: "avatar_grassroot")
//            }
//        }
        // 用switch实现条件判断
        switch status.user?.verified_type {
        case 0:
            verifyIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifyIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifyIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        // toolBar 设置
        repostStr = textFromCount(count: status.reposts_count, defaultStr: "转发")
        commentStr = textFromCount(count: status.comments_count, defaultStr: "评论")
        likeStr = textFromCount(count: status.attitudes_count, defaultStr: "点赞")
        
        // pictureView的设置
//        let pictureHeight = (screenWidth - 2*12 - 2*3)/3
//        let count = status.pic_urls?.count ?? 0
//        let row =  count/3 + (count%3 > 0 ? 1 : 0)
//        var height = pictureHeight*CGFloat(row) + CGFloat(3*(count/3))
//        height > 0 ? height += 12 : ()
//        pictureViewSize = CGSize(width: screenWidth-2*12, height: height)
        
        if status.pic_urls == nil || status.pic_urls?.count == 0 {
            pictureViewSize = CGSize.zero
        }else {
            let count = status.pic_urls!.count
            var height:CGFloat = DWZStatusPictureOutterMargin
            let row = (count-1)/3+1
            let pictureHeight = (screenWidth - 2*DWZStatusPictureOutterMargin - 2*DWZStatusPictureInnerMargin)/3
            height += CGFloat(row)*pictureHeight
            height += CGFloat(row-1)*3
            
            pictureViewSize = CGSize(width: screenWidth-DWZStatusPictureOutterMargin*2, height: height)
        }
        
        // 文字的限制范围
        let viewSize = CGSize(width: screenWidth-2*DWZStatusPictureOutterMargin, height: CGFloat(MAXFLOAT))
        if status.retweeted_status != nil {
            let retweetText = "@:\(status.user?.screen_name ?? "")" +
            "\(status.retweeted_status?.text ?? "")"
            var textHeight = retweetText.boundingRect(with: viewSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context: nil).height
            let count = status.retweeted_status?.pic_urls?.count ?? 0
//            textHeight += DWZStatusPictureOutterMargin
            if count > 0 {
                let row = (count-1)/3+1
                let pictureHeight = (screenWidth - 2*DWZStatusPictureOutterMargin - 2*DWZStatusPictureInnerMargin)/3
                textHeight += CGFloat(row)*pictureHeight
                textHeight += CGFloat(row-1)*3
                
                textHeight += 12
            }
            textHeight += 2*DWZStatusPictureOutterMargin
            
            retweetViewHeight = textHeight
            retweetStatusText = retweetText
        }else {
            retweetViewHeight = 0
            retweetStatusText = ""
        }
    }
    
    var description: String {
        return status.yy_modelDescription()
    }
    
    func textFromCount(count: Int ,defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }else if count < 10000 {
            return "\(count)"
        }else {
            return "\(CGFloat(count)/10000)"
        }
    }
}
