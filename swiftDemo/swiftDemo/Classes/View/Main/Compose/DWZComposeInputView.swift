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
    
    /// 分页控件
    lazy var pageControl = UIPageControl()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    /// 根据当前偏移量计算出UIPageControl的总页数和当前选中页数
    func calculater(offsetX: CGFloat) -> ((total: Int, current: Int)) {
        let page: CGFloat = offsetX/keyBoardView.bounds.width
        /// 累计之前的总页数
        var count = 0
        for (_,package) in DWZEmoticonManager.shared.packages.enumerated() {
            let preTotal = count
            count += package.numberOfPages
            if (CGFloat)(count) >= page {
                return (package.numberOfPages, Int(page+0.5)-preTotal)
            }
        }
        return (0,0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
}

extension DWZComposeInputView {
    func setupUI() {
        toolBarView.delegate = self
        addSubview(toolBarView)
        addSubview(keyBoardView)
        addSubview(pageControl)

        keyBoardView.backgroundColor = .white
        keyBoardView.showsVerticalScrollIndicator = false
        keyBoardView.bounces = false
        keyBoardView.isPagingEnabled = true
        keyBoardView.register(DWZKeyboardCollectionViewCell.self, forCellWithReuseIdentifier: keyboardCellID)
        keyBoardView.dataSource = self
        keyBoardView.delegate = self
        
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        pageControl.numberOfPages = DWZEmoticonManager.shared.packages[0].numberOfPages
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .orange
        
        keyBoardView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(toolBarView.snp_top);
        }
        pageControl.snp.makeConstraints { (make) in
            make.width.equalTo(160)
            make.centerX.equalTo(self)
            make.bottom.equalTo(keyBoardView)
            make.height.equalTo(16)
        }
        toolBarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self);
            make.height.equalTo(40)
        }
        
        /// 设置PageControl的选中和默认图片(tintColr用图片的平铺颜色，图片显示会有问题)
        guard let norImage = UIImage(named: "compose_keyboard_dot_normal", in: DWZEmoticonManager.shared.bundle, compatibleWith: nil), let selImage = UIImage(named: "compose_keyboard_dot_selected", in: DWZEmoticonManager.shared.bundle, compatibleWith: nil) else {
            return
        }
        pageControl.setValue(norImage, forKey: "_pageImage")
        pageControl.setValue(selImage, forKey: "_currentPageImage")
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
        /// 判断是否删除按钮,是否是keyBoardView的cell，是否是第0组(不参与排序)
        guard let emoji = emoticon,
        let indexPath = keyBoardView.indexPath(for: cell),
        indexPath.section != 0 else {
            return
        }
        DWZEmoticonManager.shared.insetEmojiInCurrent(emoji: emoji)
        keyBoardView.reloadItems(at: [indexPath])
    }
}

// MARK: - DWZComposeInputToolBarDelegate
extension DWZComposeInputView: DWZComposeInputToolBarDelegate {
    func emojiKeyboardToolBarClick(composeInputToolBar: DWZComposeInputToolBar, index: Int) {
        keyBoardView.scrollToItem(at: IndexPath(item: 0, section: index), at: .centeredHorizontally, animated: true)
        composeInputToolBar.currentSelectdIndex = index
        pageControl.currentPage = 0
    }
}

// MARK: - UICollectionViewDelegate
extension DWZComposeInputView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        /// 判断中心点位置
        let indexs = keyBoardView.indexPathsForVisibleItems
        var targetIndex: IndexPath?
        for indexPath in indexs {
            let cell = keyBoardView.cellForItem(at: indexPath)
            if cell?.frame.contains(center) == true {
                targetIndex = indexPath
                break
            }
        }
        guard let target = targetIndex else {
            return
        }
        
        /// 设置toolBar的选中视图
        toolBarView.currentSelectdIndex = target.section
        
        pageControl.numberOfPages = DWZEmoticonManager.shared.packages[target.section].numberOfPages
        pageControl.currentPage = target.item
    }
}
