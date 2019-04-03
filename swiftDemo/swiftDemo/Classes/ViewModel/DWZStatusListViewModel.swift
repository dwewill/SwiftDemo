//
//  DWZStatusListViewModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation


/// 微博视图模型
class DWZStatusListViewModel {
    lazy var statusList = [DWZStatus]()
    
    
    /// 加载微博列表
    ///
    /// - Parameter completiton: 是否成功回调
    func loadStatus(completiton:@escaping (_ isSuccess: Bool)->()) {
        DWZNetworkManager.shared.statusList { (list, isSuccess) in
            // 利用YYModel 字典转模型
            for dic in list ?? [] {
                guard let id = dic["id"] as? Int64,let text = dic["text"] as? String else {
                    print("id 或者 text 为空")
                    continue
                }
                let model = DWZStatus()
                model.text = text
                model.id = id
                self.statusList.append(model)
            }
            completiton(isSuccess)
        }
    }
}
