//
//  DWZNetworkManager+Extension.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation


// MARK: - 发布微博
extension DWZNetworkManager {
    func postStatus(text: String?, image: UIImage?, completion:@escaping (( _ list:[String:Any]?, _ isSuccess: Bool)->())) {
        /// 有图片的微博和无图的微博接口处理
        let urlString: String
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        let statusText = text ?? ""
        /// 参数字典
        let params = ["status": statusText]
        
//        /// 如果图片不为空，要传name 和 data字段
//        let name: String?
//        let data: Data?
//        if image != nil {
//            name = "pic"
//            data = image!.pngData()
//        }
        
        accessTokenRequest(method: .POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            let result = json as? [String: Any]
            completion(result,isSuccess)
        }
    }
}

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
    
    
    /// 未读消息数量
    ///
    /// - Parameter completion: 请求回调
    func unreadCount(completion:@escaping (_ count:Int)->()) {
        guard let uid = DWZUser.uid else {
            print("没有获取到uid")
            return
        }
        let url = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let parameters = ["uid": uid]
        accessTokenRequest(URLString: url, parameters: parameters) { (json,isSuccess) in
            let dic = json as? [String:Any]
            let count = dic?["status"] as? Int ?? 0
            completion(count)
        }
    }
    
    func loadUserInfo(completion:@escaping (( _ response:[String:Any]?)->())) {
        let url = "https://api.weibo.com/2/users/show.json"
        guard let uid = DWZUser.uid else {
            print("没有获取到uid")
            return
        }
        let params = ["uid": uid]
        accessTokenRequest(URLString: url, parameters: params) { (json, isSuccess) in
            completion(json as? [String: Any])
        }
    }
    
    /// 获取Access_token
    ///
    /// - Parameters:
    ///   - authCode: 授权码
    ///   - completion: 结果回调
    func requestAccessToken(authCode: String, completion:@escaping (( _ isSuccess: Bool)->())) {
        let url = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":DWZAppKey,
                      "client_secret":DWZAPPSecret,
                      "grant_type":"authorization_code",
                      "code":authCode,
                      "redirect_uri":DWZRedirectURI]
        request(method: .POST, URLString: url, parameters: params) { (json, isSuccess) in
            self.DWZUser.yy_modelSet(with: json as? [String: Any] ?? [:])
            self.loadUserInfo(completion: { (dict) in
                self.DWZUser.yy_modelSet(with: dict ?? [:])
                self.DWZUser.saveUserInfo()
                completion(isSuccess)
            })
        }
    }
}
