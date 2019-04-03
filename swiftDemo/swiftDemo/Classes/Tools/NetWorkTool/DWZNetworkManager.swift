//
//  DWZNetworkManager.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import AFNetworking


/// 网络管理工具
class DWZNetworkManager: AFHTTPSessionManager {
    static let shared = DWZNetworkManager()
}
