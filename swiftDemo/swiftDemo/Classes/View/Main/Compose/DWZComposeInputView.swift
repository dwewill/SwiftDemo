//
//  DWZComposeInputView.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/16.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

/// cellID
let keyboardCellID = "keyboardCellID"

class DWZComposeInputView: UIView {
    /// emoji键盘点击事件回调block
    var emojiClickCallback: ((_ emoji: DWZEmoticon?)->())?
        
    /// 键盘视图CollectionView
    lazy var keyBoardView = UICollectionView(frame: .zero, collectionViewLayout: DWZCollectionViewLayout())
    
    /// 底部工具栏
    lazy var toolBarView = DWZComposeInputToolBar()
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DWZComposeInputView {
    func setupUI() {
        toolBarView.delegate = self
        addSubview(toolBarView)
        addSubview(keyBoardView)
        keyBoardView.backgroundColor = .white
        keyBoardView.showsVerticalScrollIndicator = false
        keyBoardView.bounces = false
        keyBoardView.isPagingEnabled = true
        keyBoardView.register(DWZKeyboardCollectionViewCell.self, forCellWithReuseIdentifier: keyboardCellID)
        keyBoardView.dataSource = self
        keyBoardView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(toolBarView.snp_top);
        }
        toolBarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(40)
        }
    }
}

extension DWZComposeInputView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DWZEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DWZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keyboardCellID, for: indexPath) as? DWZKeyboardCollectionViewCell
        cell?.emoticons = DWZEmoticonManager.shared.packages[indexPath.section].emotionsOfPage(page: indexPath.item)
        cell?.delegate = self
        return cell ?? DWZKeyboardCollectionViewCell()
    }
}

// MARK: - DWZKeyboardCollectionViewCellDelegate
extension DWZComposeInputView: DWZKeyboardCollectionViewCellDelegate {
    func emoticonClick(cell: DWZKeyboardCollectionViewCell, emoticon: DWZEmoticon?) {
        emojiClickCallback?(emoticon)
    }
}

// MARK: - DWZComposeInputToolBarDelegate
extension DWZComposeInputView: DWZComposeInputToolBarDelegate {
    func emojiKeyboardToolBarClick(index: Int) {
        keyBoardView.scrollToItem(at: IndexPath(item: 0, section: index), at: .centeredHorizontally, animated: true)
    }
}
