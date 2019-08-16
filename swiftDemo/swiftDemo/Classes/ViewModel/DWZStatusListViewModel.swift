//
//  DWZStatusListViewModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/3.
//  Copyright © 2019 段文拯. All rights reserved.
//

import Foundation
import SDWebImage

private let maxPullUpTryTimes = 3

/// 微博视图模型
class DWZStatusListViewModel {
    lazy var statusList = [DWZStatusViewModel]()
    
    // 上拉没有新数据的次数(避免过多的空请求到服务器)
    private var pullUpErrorTime = 0
    
    /// 加载微博列表
    /// - Parameter isPullUp: 是否下拉
    /// - Parameter completiton: 是否成功回调(是否成功，是否需要刷新数据)
    func loadStatus(isPullUp: Bool, completiton:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        if isPullUp && pullUpErrorTime > maxPullUpTryTimes {
            completiton(true, false)
            return
        }
        
        let since_id = isPullUp ? 0 : statusList.first?.status.id ?? 0
        let max_id = !isPullUp ? 0 : statusList.last?.status.id ?? 0
        DWZNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            // 利用YYModel 字典转模型
            var array = [DWZStatusViewModel]()
            for dic in list ?? [] {
                let model = DWZStatus()
                model.yy_modelSet(with: dic)
                array.append(DWZStatusViewModel(status: model))
            }
            print("刷新 \(array.count)条数据")
            if isPullUp {
                self.statusList += array
            }else {
                self.statusList = array + self.statusList
            }
            if array.count == 0 && isPullUp {
                self.pullUpErrorTime += 1
                completiton(isSuccess, false)
            }else {
                self.cacheSigleImage(array, completiton: completiton)
//                completiton(isSuccess, true)
            }
            
        }
    }
    
    
    /// 缓存本次微博数据中的单张图片数据
    ///
    /// - Parameter list: 视图模型数组
    func cacheSigleImage(_ list: [DWZStatusViewModel],completiton:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        //  记录数据的长度
        var length = 0
        
        for statusViewModel in list {
            
            if statusViewModel.picURLs?.count != 1 {
                continue
            }
            guard let pic = statusViewModel.picURLs?.first!.thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
                }
            
                group.enter()
                SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                    if let image = image,
                        let data = image.pngData() {
                        length += data.count
//                        statusViewModel.updateSigleImageSize(image: image)
                    }
                    print("缓存的图像 \(image)")
                    group.leave()
                }
            }
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成 大小\(length)")
            completiton(true,true)
        }
    }
}
