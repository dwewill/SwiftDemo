//
//  DWZNetworkManager+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation

extension DWZNetworkManager {
    
    /// 微博列表数据请求
    ///
    /// - Parameters:
    ///   - since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    func statusList(since_id: Int64 = 0,max_id: Int64 = 0,completion:@escaping (( _ list:[[String:Any]]?, _ isSuccess: Bool)->())) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["since_id":"\(since_id)", "max_id": "\(max_id > 0 ? max_id-1 : 0)"]
        accessTokenRequest(URLString: url, parameters: parameters) { (json,isSuccess) in
            let result = (json as? [String:Any])?["statuses"] as? [[String:Any]]
            completion(result,isSuccess)
        }
    }
}
