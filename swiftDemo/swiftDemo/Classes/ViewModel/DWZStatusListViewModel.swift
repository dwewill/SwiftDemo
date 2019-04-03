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
        let since_id = statusList.first?.id ?? 0
        DWZNetworkManager.shared.statusList(since_id: since_id, max_id: 0) { (list, isSuccess) in
            // 利用YYModel 字典转模型
            var array = [DWZStatus]()
            for dic in list ?? [] {
                guard let id = dic["id"] as? Int64,let text = dic["text"] as? String else {
                    print("id 或者 text 为空")
                    continue
                }
                let model = DWZStatus()
                model.text = text
                model.id = id
                array.append(model)
            }
            self.statusList = array + self.statusList
            completiton(isSuccess)
        }
    }
}
