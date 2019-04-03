//
//  DWZNetworkManager+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation
 
extension DWZNetworkManager {
    func statusList(completion:@escaping (( _ list:[[String:Any]]?, _ isSuccess: Bool)->())) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token":"2.00uz9raGXmm97C4708775a30TOtTjD"]
        request(URLString: url, parameters: params) { (json,isSuccess) in
            let result = (json as? [String:Any])?["statuses"] as? [[String:Any]]
            completion(result,isSuccess)
        }
    }
}
