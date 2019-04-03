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
    var id: Int64 = 0
    // 微博内容
    var text: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
