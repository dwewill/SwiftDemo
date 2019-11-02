//
//  Date+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/19.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation


///// 日期格式化对象，不能频繁创建和销毁，影响性能
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    return formatter
//}()
//
///// 日期格式化对象，用来格式化微博来源字符串的
//private let createDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
//    return formatter
//}()

/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()

// MARK: - 日期的分类，格式化日期
extension Date {
    
    /// 格式化指定时间差的时间，返回字符串
    ///
    /// - Parameter delta: 时间差
    /// - Returns: 结果字符串
    func dateString(delta: TimeInterval) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date(timeIntervalSinceNow: delta))
    }
    
    
    /// sina 格式化字符串
    ///
    /// - Parameter dateString: 日期格式字符串
    /// - Returns: 日期
    static func sinaDataFromString(dateString: String) -> Date? {
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        return dateFormatter.date(from: dateString)
    }
}
