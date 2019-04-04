//
//  DWZUserModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/4.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZUserModel: NSObject {
    // token
    var access_token: String? = "2.00uz9raGXmm97C4708775a30TOtTjD"
    // 授权用户的UID
    var uid: String?
    // access_token的生命周期，单位是秒数。
    var expires_in: TimeInterval = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
