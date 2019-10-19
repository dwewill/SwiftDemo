//
//  Date+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/19.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation


/// 日期格式化对象，不能频繁创建和销毁，影响性能
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

// MARK: - 日期的分类，格式化日期
extension Date {
    
    /// 格式化指定时间差的时间，返回字符串
    ///
    /// - Parameter delta: 时间差
    /// - Returns: 结果字符串
    func dateString(delta: TimeInterval) -> String {
        return dateFormatter.string(from: Date(timeIntervalSinceNow: delta))
    }
}
