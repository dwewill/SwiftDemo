//
//  DWZEmoticonPackage.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/30.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit


/// 表情分类模型，存储的是同类型表情模型集合
class DWZEmoticonPackage: NSObject {
    /// 表情包页数
    var numberOfPages: Int  {
        return (emoticons.count - 1)/20+1
    }
    
    /// 计算出每页显示的数据
    func emotionsOfPage(page: Int) ->([DWZEmoticon]) {
        var emos = [DWZEmoticon]()
        for i in 0..<20 {
            if page*20+i >= emoticons.count {
                break
            }
            let emo = emoticons[page*20+i]
            emos.append(emo)
        }
        return emos
    }
    
    /// 表情包分组名称
    @objc var groupName: String?
    
    /// 表情包目录,从目录中加载表情包数据
    @objc var directory: String? {
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let emoticonPath = bundle.path(forResource: directory+"/info.plist", ofType: nil),
                let emoticonsArray = NSArray(contentsOfFile: emoticonPath) as? [[String: String]],
                let emoticonModels = NSArray.yy_modelArray(with: DWZEmoticon.self, json: emoticonsArray) as? [DWZEmoticon] else {
                return
            }
            emoticons += emoticonModels
            for emotion in emoticons {
                emotion.directory = directory
            }
        }
    }
    
    /// 表情模型的空数组，用懒加载
    @objc lazy var emoticons: [DWZEmoticon] = [DWZEmoticon]()
    
    override var description: String {
        return yy_modelDescription()
    }
}
