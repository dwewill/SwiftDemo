//
//  Bundle+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation

extension Bundle {
    // 计算属性类似函数，没有参数，有返回值 等同于OC调用方法无参数有返回值的方法copy
    var namesspace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
