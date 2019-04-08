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
    
    init(status: DWZStatus) {
        self.status = status
        
        if let mbarank = status.user?.mbrank {
            if mbarank > 0 && mbarank < 7 {
                memberIcon = UIImage(named: "common_icon_membership_level\(mbarank)")
            }
        }
        
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
        
    }
    
    var description: String {
        return status.yy_modelDescription()
    }
    
}
