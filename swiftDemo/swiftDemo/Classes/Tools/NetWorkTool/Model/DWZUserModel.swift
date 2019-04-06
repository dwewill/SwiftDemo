//
//  DWZUserModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/4.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

private let accountFile: NSString = "account.data"

class DWZUserModel: NSObject {
    // token
    @objc var access_token: String? // = "2.00uz9raGXmm97C4708775a30TOtTjD"
    // 授权用户的UID
    @objc var uid: String?
    // access_token的生命周期，单位是秒数。
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //过期日期
    @objc var expiresDate: Date?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        guard let filePath = accountFile.cz_appendTempDir(),
            let data = NSData(contentsOfFile: filePath) as Data?,
        let serializaData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
        let account = serializaData else {
                print("读取：data格式不正确为空或者filePath拼接错误")
                return
        }
        self.yy_modelSet(with: account)
    }
    
    /// 存入本地文件
    func saveUserInfo() {
        // FIXME: - 用yy_modelToJSONObject失败，原因是swift4之后不主动桥接到oc，需要主动设置运行时可获取
        var dic = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        dic.removeValue(forKey: "expires_in")
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
            let filePath = accountFile.cz_appendTempDir() else {
                print("写入：data格式不正确为空或者filePath拼接错误")
                return
        }
        let result = (data as NSData).write(toFile: filePath, atomically: true)
        print("写入结果:\(result)--\(filePath)")
        
    }
}
