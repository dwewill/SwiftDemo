//
//  DWZSQLiteManager.swift
//  FMDBDemo
//
//  Created by 段文拯 on 2019/5/2.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation
import FMDB

/// 数据库管理工具类
class DWZSQLiteManager {
    
    // 数据库工具单例
    static let shared = DWZSQLiteManager()
    
    // 数据库队列
    let queue: FMDatabaseQueue
    
    // 构造函数
    private init() {
        let filePath = "status.db"
        let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = (searchPath as NSString).appendingPathComponent(filePath)
        print("数据库路径\(path)")
        // 创建数据库队列，同时“创建或者打开”数据库
        queue = FMDatabaseQueue(path: path)!
        print(queue)
        createTable()
    }
}

// 数据库查询操作
extension DWZSQLiteManager {
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
            let dic = json as? [String: Any] else {
                    continue
            }
            result.append(dic)
        }
        return result
    }
    
    func updateStatus(_ userId: String, _ array: [[String:Any]]) {
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,userId,status) VALUES (?,?,?)"
        for dic in array {
            guard let statusId = dic["idStr"],
                let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
                    continue
            }
            
            queue.inTransaction { (db, rollBack) in
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
