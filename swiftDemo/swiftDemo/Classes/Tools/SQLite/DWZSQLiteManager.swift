//
//  DWZSQLiteManager.swift
//  FMDBDemo
//
//  Created by 段文拯 on 2019/5/2.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation
import FMDB

/// 有效存储时间为5天
let vaildCacheTime: TimeInterval = -60 //-5*24*60*60

/// 数据库管理工具类
/// 数据库的每一条SQL必须先测试通过之后，再加入项目，排查问题异常麻烦
class DWZSQLiteManager {
    
    // 数据库工具单例
    static let shared = DWZSQLiteManager()
    
    // 数据库队列
    let queue: FMDatabaseQueue
    
    // 构造函数（private 防止外部私自调用）
    private init() {
        let filePath = "status.db"
        let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = (searchPath as NSString).appendingPathComponent(filePath)
        print("数据库路径\(path)")
        // 创建数据库队列，同时“创建或者打开”数据库
        queue = FMDatabaseQueue(path: path)!
        print(queue)
        createTable()
        
        /// 监听程序进入后台，调用清理数据库的方法
        NotificationCenter.default.addObserver(self, selector: #selector(clearDBCache), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// 数据库查询操作
extension DWZSQLiteManager {
    
    /// 清理数据库的方法
    @objc func clearDBCache() {
        let time = Date().dateString(delta: vaildCacheTime)
        print("过期时间\(time)")
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        
        queue.inDatabase { (db) in
            if db.executeUpdate(sql, withArgumentsIn: [time]) {
                print("删除成功 影响了\(db.changes)")
            }else {
                print("删除失败")
            }
        }
        
//        // 执行 SQL
//        queue.inDatabase { (db) in
//
//            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
//
//                print("删除了 \(db?.changes()) 条记录")
//            }
//        }
    }
    
    /// 查询数据库
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 查询到的结果
    func execRecordSet(_ sql: String) -> [[String:Any]] {
        var result = [[String: Any]]()
        queue.inDatabase { (db) in
            guard let rs = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            while rs.next() {
                let colCount = rs.columnCount
                for col in 0..<colCount {
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col) else {
                            continue
                    }
                    result.append([name: value])
                }
            }
        }
        return result
    }
}

// 数据库更新操作
extension DWZSQLiteManager {
    
    /// 从数据库加载数据
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - since_id: 加载比since_id大的数据
    ///   - max_id: 加载比max_id小的数据
    /// - Returns: 查询到的微博数据，反序列化，字典数组
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: Any]] {
        // 1.准备SQL
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        // 上/下 拉，判断
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        }else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        // 2.执行SQL
        let array = execRecordSet(sql)
        
        // 3.遍历数组，将数组中的 status 反序列化 -> 字典的数组
        var result = [[String: Any]]()
        
        for dic in array {
            guard let jsonData = dic["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let res = json as? [String: Any] else {
                    continue
            }
            result.append(res)
        }
        return result
    }
    
    
    /// 更新/新增微博数据
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - array: 微博数据(微博数据中包含了statusId)
    func updateStatus(_ userId: String, _ array: [[String:Any]]) {
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,userId,status) VALUES (?,?,?)"
        queue.inTransaction { (db, rollBack) in
            /// 遍历返回的微博字典数组，遍历插入
            for dic in array {
                guard let statusId = dic["idstr"],
                    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
                        continue
                }
                
                if db.executeUpdate(sql, withArgumentsIn: [statusId,userId,jsonData]) == false {
                    rollBack.pointee = true
                    print("更新失败")
                }
                
            }
        }
    }
}

// 创建数据库表以及其它方法
extension DWZSQLiteManager {
    fileprivate func createTable() {
        // 准备SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
           let sql = try? String(contentsOfFile: path) else {
            return
        }
        
        // 执行SQL 串行队列，同步执行，保证数据的读写安全
        queue.inDatabase { (db) in
            if db.executeStatements(sql) == true {
                print("创表成功")
            }else {
                print("创表失败")
            }
        }
        print("OVER")
    }
    
}
