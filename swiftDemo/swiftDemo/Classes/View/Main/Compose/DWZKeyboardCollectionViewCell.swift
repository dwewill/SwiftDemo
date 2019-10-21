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
    
    /// 键盘长按显示视图
    private var emoticonTipView = DWZEmoticonTipView()
    
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
    
    /// 视图添加到window的时候调用，移除子视图也会调用newWindow为nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let window = newWindow else {
            return
        }
        window.addSubview(emoticonTipView)
        emoticonTipView.isHidden = true
    }
    
    
    @objc func emojiClick(sender: UIButton) {
        if sender.tag == 20 {
            delegate?.emoticonClick?(cell: self, emoticon: nil)
            return
        }
        let em = emoticons?[sender.tag]
        delegate?.emoticonClick?(cell: self, emoticon: em)
    }
    
    
    /// EMOJI的长按手势
    ///
    /// - Parameter longPress: 长按手势参数
    @objc func emojiLongpress(longPress: UILongPressGestureRecognizer) {
        print(longPress)
        /// 找到触摸点
        let point = longPress.location(in: self)
        /// 判断长按的按钮
        let btn = buttonContainsLocation(location: point)
        /// 判断是否为删除按钮
        guard let button = btn else {
            emoticonTipView.isHidden = true
            return
        }
        
        /// 处理手势状态
        switch longPress.state {
        case .began, .changed:
            let center = convert(button.center, to: window)
            emoticonTipView.center = center
            emoticonTipView.isHidden = false
            if button.tag < emoticons?.count ?? 0 {
                emoticonTipView.emoticon = emoticons?[button.tag]
            }
        case .ended:
            emoticonTipView.isHidden = true
            emojiClick(sender: button)
        case .cancelled, .failed:
            emoticonTipView.isHidden = true
        default:
            break
        }
        
        print(button)
    }
    
    /// 根据触摸点找寻点击的按钮
    ///
    /// - Parameter location: location
    @objc func buttonContainsLocation(location: CGPoint) -> UIButton? {
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        return nil
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
        
        /// 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(emojiLongpress(longPress:)))
        longPress.minimumPressDuration = 0.2
        addGestureRecognizer(longPress)
    }
    
    
}
