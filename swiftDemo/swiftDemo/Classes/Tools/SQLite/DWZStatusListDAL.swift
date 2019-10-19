//
//  DWZStatusListDAL.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/18.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation

/// 数据访问层，用来处理是本地/网络获取数据
class DWZStatusListDAL {
    
    /// 加载数据
    ///
    /// - Parameters:
    ///   - since_id: since_id
    ///   - max_id: max_id
    ///   - completion: 完成回调
    func loadStatus(since_id: Int64 = 0,max_id: Int64 = 0,completion:@escaping (( _ list:[[String:Any]]?, _ isSuccess: Bool)->())) {
        // 取用户的id
        guard let uid = DWZNetworkManager.shared.DWZUser.uid  else {
            return
        }
        // 1、判断本地是否有缓存数据，有的话从本地加载并返回
        let array = DWZSQLiteManager.shared.loadStatus(userId: uid, since_id: since_id, max_id: max_id)
        if array.count > 0 {
            completion(array,true)
            return
        }
        
        // 2、从网络加载数据，缓存到本地数据库并返回
        DWZNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            /// 请求失败
            if !isSuccess {
                completion(nil,false)
                return
            }
            
            guard let list = list else {
                completion(nil,true)
                return
            }
            /// 缓存到数据库
            DWZSQLiteManager.shared.updateStatus(uid, list)
            
            completion(list,true)
        }
    }
}
