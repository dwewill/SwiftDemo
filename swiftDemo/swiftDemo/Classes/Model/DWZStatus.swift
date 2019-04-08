//
//  DWZStatus.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class DWZStatus: NSObject {
    // 微博id
    @objc var id: Int64 = 0
    // 微博内容
    @objc var text: String?
    // 用户模型
    @objc var user: DWZUser?
    // 创建时间
    @objc var created_at: String?
    // 微博来源
    @objc var source: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
