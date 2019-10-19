//
//  DWZComposeViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/9/27.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import SVProgressHUD

class DWZComposeViewController: UIViewController {

     /// 发布按钮
     var sendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("发布", for: .normal)
        btn.setTitle("发布", for: .disabled)
        btn.setTitleColor(.gray, for: .disabled)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        btn.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var composeInputView: DWZComposeInputView = {
        let composeView = DWZComposeInputView()
        composeView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: keyboardHeight)
        composeView.emojiClickCallback = { [weak self] (emo:DWZEmoticon?) -> () in
            self?.insertEmoji(emoji: emo)
        }
        return composeView
    }()
    
    /// 记录键盘的高度
    var keyboardHeight: CGFloat = 0
    
    /// TextView
    lazy var textView = UITextView()
    
    /// 占位label
    lazy var label = UILabel()
    
    /// toolBar
    lazy var toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        /// 监听键盘的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// 处理键盘的显示和隐藏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


// MARK: - 交互
extension DWZComposeViewController {
    
    /// 键盘的显示和隐藏调用的方法
    ///
    /// - Parameter notification: 统计的参数
    @objc private func keyboardChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
        let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
        let rect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue else {
            return
        }
        if keyboardHeight == 0 {
            keyboardHeight = rect.height
        }
        let offset = view.bounds.height-rect.origin.y
        let safeHeight: CGFloat = offset == 0 ? safeAreaHeight : 0
        
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(-offset-safeHeight)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    /// 处理表情键盘的输入
    ///
    /// - Parameter emoji: emoji对象
    @objc private func insertEmoji(emoji: DWZEmoticon?) {
        /// 删除
        guard let emoji = emoji else {
            print("删除")
            textView.deleteBackward()
            return
        }
        
        /// emoji表情
        if let emojiStr = emoji.emoji, let textRange = textView.selectedTextRange {
            textView.replace(textRange, withText: emojiStr)
            return
        }
        
        /// 表情
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        /// 记录光标的位置并回复
        let range = textView.selectedRange
        let imageText = emoji.imageText(font: textView.font!)
        attributedText.replaceCharacters(in: textView.selectedRange, with: imageText)
        textView.attributedText = attributedText
        textView.selectedRange = NSRange(location: range.location+1, length: 0)
        textViewDidChange(textView)
    }
    
    /// 切换键盘视图的关键代码
    @objc private func emoticonKeyboard() {
//        composeInputView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: keyboardHeight)
//        composeInputView.emojiClickCallback = { [weak self] (emo:DWZEmoticon?) -> () in
//            self?.insertEmoji(emoji: emo)
//        }
        
        /// 设置键盘视图，系统键盘弹出的时候inputView为nil
        textView.inputView = textView.inputView == nil ? composeInputView : nil
//        // UIView
//        let v = UIView()
//        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: keyboardHeight)
//        v.backgroundColor = .cyan
//        textView.inputView = textView.inputView == nil ? v : nil
        /// 设置键盘视图要更新inputView
        textView.reloadInputViews()
    }
    
    @objc private func cancelButtonClick() {
        print("cancelButtonClick")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func attributedConvertToText() -> String {
        var result = ""
        guard let attr = textView.attributedText else {
            return result
        }
        textView.attributedText.enumerateAttributes(in: NSRange(location: 0, length: textView.attributedText.length), options: []) { (dic, range, _) in
            if let attachment = dic[NSAttributedString.Key.attachment] as? DWZEmoticonAttahment {
                result += attachment.chs ?? ""
               print("图片")
            }else {
                let subStr = (attr.string as NSString).substring(with: range)
                result += subStr
                print(subStr)
            }
            
        }
        return result
    }
    
    // FIXME: - 因为接口变更，发布微博接口被禁用
    @objc private func sendButtonClick() {
        print("sendButtonClick")
        print(attributedConvertToText())
//        DWZNetworkManager.shared.postStatus(text: textView.text, image: nil) { (json, isSuccess) in
//            let message = isSuccess ? "发布成功" : "网络状态不好"
//            if isSuccess == false {
//                SVProgressHUD.showInfo(withStatus: message)
//                SVProgressHUD.setDefaultStyle(.dark)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
//                    SVProgressHUD.setDefaultStyle(.light)
//                    self.dismiss(animated: true, completion: nil)
//                })
//            }
//        }
    }
}

// MARK: - UI搭建
extension DWZComposeViewController {
    private func setupUI() {
        title = "发布"
        view.backgroundColor = .white
        setupNavigationBar()
        setupTextView()
        setupToolBar()
    }
    
    
    /// 设置textView
    func setupTextView() {
        textView.text = ""
        textView.frame = CGRect(x: 0, y: navigationHeight, width: screenWidth, height: screenHeight-safeAreaHeight-49-navigationHeight)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .onDrag
        textView.delegate = self
        textView.font = .systemFont(ofSize: 16)
        view.addSubview(textView)
        
        label.frame = CGRect(x: 5, y: 5, width: screenWidth-10, height: 24)
        textView.addSubview(label)
        label.text = "你想说点什么..."
        label.font = textView.font
        label.textColor = .orange
    }
    
    
    /// 设置工具栏
    func setupToolBar() {
//        toolbar.frame = CGRect(x: 0, y: screenHeight-safeAreaHeight-49, width: screenWidth, height: 49)
        toolbar.backgroundColor = .lightGray
        toolbar.frame = CGRect.zero
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        var items = [UIBarButtonItem]()
        for i in itemSettings {
            guard let imageName = i["imageName"],
                  let image = UIImage(named: imageName),
                  let highlightImage = UIImage(named: imageName+"_highlighted") else {
                continue
            }
            let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.setImage(highlightImage, for: .highlighted)
            btn.sizeToFit()
            
            if let actionName = i["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            // 添加控件
            items.append(UIBarButtonItem(customView: btn))
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        view.addSubview(toolbar)
        
        toolbar.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-safeAreaHeight)
            make.height.equalTo(49)
        }
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", action: self, selector: #selector(cancelButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
        setupTitleLabel()
    }
    
    
    /// 设置title富文本
    func setupTitleLabel() {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let prefix = "NULL"
        let name = "一剪寒梅"
        let str = prefix+"\n"+name
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor: UIColor.orange], range:(str as NSString).range(of: prefix))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: (str as NSString).range(of: name))
        
        label.attributedText = attributedString
        label.sizeToFit()
        navigationItem.titleView = label
    }
}

extension DWZComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        label.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
