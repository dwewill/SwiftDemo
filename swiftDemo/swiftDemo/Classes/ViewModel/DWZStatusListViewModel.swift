//
//  DWZStatusListViewModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation


/// 微博模型数组ViewModel
class DWZStatusListViewModel {
    lazy var statusList = [DWZStatus]()
    
    
    /// 加载微博列表
    ///
    /// - Parameter completiton: 是否成功回调
    func loadStatus(completiton:@escaping (_ isSuccess: Bool)->()) {
        DWZNetworkManager.shared.statusList { (list, isSuccess) in
            // 利用YYModel 字典转模型
            guard let modelArray = NSArray.yy_modelArray(with: DWZStatus.self, json: list ?? []) as? [DWZStatus] else {
                completiton(isSuccess)
                return
            }
            self.statusList += modelArray
            completiton(isSuccess)
        }
    }
}
