//
//  ViewController.swift
//  EmotionDemo
//
//  Created by 段文拯 on 2019/10/12.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var demoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 我[爱你]很[笑哈哈]
        let str =  "我[爱你]很[笑哈哈]"
        let attributed = NSMutableAttributedString(string: str)
        let pattern = "\\[.*?\\]"
        let regu = try? NSRegularExpression(pattern: pattern, options: [])
        let matchs = regu?.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
        guard let ms = matchs else {
            return
        }
        for m in ms.reversed() {
            let r = m.range(at: 0)
            let sub = (str as NSString).substring(with: r)
            let em = DWZEmoticonManager.shared.matchStringWithEmotion(string: sub)
            let att = em?.imageText(font: .systemFont(ofSize: 20)) ?? NSAttributedString(string: "")
            attributed.replaceCharacters(in: r, with: att)
        }
        
        demoLabel.attributedText = DWZEmoticonManager.shared.emoticonString(string: str, font: .systemFont(ofSize: 20))
    }

    func setupUI() {
        view.addSubview(demoLabel)
        demoLabel.font = .systemFont(ofSize: 20)
        demoLabel.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100)
    }
    

}

