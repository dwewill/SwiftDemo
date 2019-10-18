//
//  DWZCollectionViewLayout.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/16.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        let collectionSize = collectionView?.frame.size ?? CGSize.zero
        
        itemSize = CGSize(width: collectionSize.width, height: collectionSize.height)
        
    }
}
