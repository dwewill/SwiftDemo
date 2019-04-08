//
//  DWZUser.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

@objcMembers

/// 用户模型
class DWZUser: NSObject {
    // id
    var id: Int64 = 0
    // 用户昵称
    var screen_name: String?
    // 用户头像地址(中图)， 50*50像素
    var profile_image_url: String?
    // 认证类型 -1：没有认证， 0 认证用户，2、3、5企业认证， 220：达人
    var verified_type: Int = 0
    // 会员等级 0-6
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
