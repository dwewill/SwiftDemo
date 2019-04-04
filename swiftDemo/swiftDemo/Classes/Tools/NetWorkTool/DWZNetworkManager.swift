//
//  DWZNetworkManager.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import AFNetworking

//定义枚举类型 GET/POST
enum DWZHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class DWZNetworkManager: AFHTTPSessionManager {
    // 网络工具单例
    static let shared:DWZNetworkManager = {
        let instance = DWZNetworkManager()
        // 设置响应序列化支持的数据格式
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    // token
    lazy var DWZUser = DWZUserModel()
    var userLogon:Bool {
        return DWZUser.access_token != nil
    }
    
    func accessTokenRequest(method: DWZHTTPMethod = .GET, URLString: String, parameters: [String: String]?, completion:@escaping (_ json:Any?, _ isSuccess: Bool)->()) {
        guard let token = DWZUser.access_token else {
            print("没有token，请登录获取")
            // FIXME: - 处理token过期
            completion(nil,false)
            NotificationCenter.default.post(name: NSNotification.Name.init(DWZUserShouldLoginNotification), object: nil)
            return
        }
        var parameters = parameters
        if parameters == nil {
            parameters = [String:String]()
        }
        parameters!["access_token"] = token
        request(URLString: URLString, parameters: parameters!, completion: completion)
    }
    
    /// 封装AFN的 GET/POST 请求
    ///
    /// - Parameters:
    ///   - method: DWZHTTPMethod，默认GET
    ///   - URLString: URLString
    ///   - parameters: 请求参数（字典类型）
    ///   - completion: 完成回调[json, isSuccess]
    func request(method: DWZHTTPMethod = .GET, URLString: String, parameters: [String: String], completion:@escaping (_ json:Any?, _ isSuccess: Bool)->()) {
        let success = { (dataTask: URLSessionDataTask, json: Any?)->() in
            completion(json,true)
        }
        let failure = { (dataTask: URLSessionDataTask?, error: Error)->() in
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                // FIXME: - 处理token过期
                print("token过期")
                NotificationCenter.default.post(name: NSNotification.Name.init(DWZUserShouldLoginNotification), object: nil)
            }
            print("请求错误--\(error)")
            completion(nil,false)
        }
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
