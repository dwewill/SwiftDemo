//
//  DWZKeyboardCollectionViewCell.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/16.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit


 /// 代理，用来处理emoji的点击事件
 @objc protocol DWZKeyboardCollectionViewCellDelegate: NSObjectProtocol {
    @objc optional func emoticonClick(cell: DWZKeyboardCollectionViewCell, emoticon: DWZEmoticon?)
}

class DWZKeyboardCollectionViewCell: UICollectionViewCell {
    
    /// 代理属性
    weak var delegate: DWZKeyboardCollectionViewCellDelegate?
    
    /// 保存键盘的按钮
    private var emoticonButtons = [UIButton]()
    /// 模型数据
    var emoticons: [DWZEmoticon]? {
        didSet {
            for btn in emoticonButtons {
                btn.isHidden = true
                btn.setImage(nil, for: .normal)
                btn.setTitle(nil, for: .normal)
            }
            
            for (i,emo) in (emoticons ?? []).enumerated() {
                let btn = emoticonButtons[i]
                btn.setImage(emo.image, for: .normal)
                btn.setTitle(emo.emoji, for: .normal)
                btn.isHidden = false
            }
            
            let btn = emoticonButtons.last
            btn?.setImage(UIImage(named: "compose_emotion_delete", in: DWZEmoticonManager.shared.bundle, compatibleWith: nil), for: .normal)
            btn?.isHidden = emoticons?.count == 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func emojiClick(sender: UIButton) {
        if sender.tag == 20 {
            delegate?.emoticonClick?(cell: self, emoticon: nil)
            return
        }
        let em = emoticons?[sender.tag]
        delegate?.emoticonClick?(cell: self, emoticon: em)
    }
}

extension DWZKeyboardCollectionViewCell {
    func setupUI() {
        let leftMargin:CGFloat = 8
        let bottomMargin:CGFloat = 16
        
        let btnWidth: CGFloat = (bounds.size.width-2*leftMargin)/7
        let btnHeight: CGFloat = (bounds.size.height-bottomMargin)/3
        
        var col:CGFloat = 0
        var row:CGFloat = 0
        for i in 0..<21 {
            let btn = UIButton()
            btn.isHidden = true
            col = CGFloat(i%7)
            row = CGFloat(i/7)
            btn.frame = CGRect(x: leftMargin+col*btnWidth, y: row*btnHeight, width: btnWidth, height: btnHeight)
            btn.titleLabel?.font = .systemFont(ofSize: 32)
            btn.adjustsImageWhenHighlighted = false
            btn.addTarget(self, action: #selector(emojiClick(sender:)), for: .touchUpInside)
            btn.tag = i
            contentView.addSubview(btn)
            emoticonButtons.append(btn)
        }
        
        let btn = emoticonButtons.last
        btn?.setImage(UIImage(named: "compose_emotion_delete", in: DWZEmoticonManager.shared.bundle, compatibleWith: nil), for: .normal)
    }
    
    
}
