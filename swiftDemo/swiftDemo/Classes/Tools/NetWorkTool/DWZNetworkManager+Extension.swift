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
        accessTokenRequest(URLString: url, parameters: nil) { (json,isSuccess) in
            let result = (json as? [String:Any])?["statuses"] as? [[String:Any]]
            completion(result,isSuccess)
        }
    }
}
