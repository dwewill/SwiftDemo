//
//  DWZBaseViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/3/31.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
let screen = UIScreen.main
let screenWidth = screen.bounds.size.width
let screenHeight = screen.bounds.size.height
let scale = screen.scale
// FIXME: - iPhone X/XS/XR/XSMAX 适配
//@available(iOS 11.0, *)
//let navHeight = (UIApplication.shared.delegate?.window ?? UIWindow(frame: screen.bounds))?.safeAreaInsets.top ?? 0 > CGFloat(20) ? 88 : 64


class DWZBaseViewController: UIViewController {
    lazy var navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
    lazy var navBarItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    override var title: String? {
        didSet {
            navBarItem.title = title
        }
    }
}

extension DWZBaseViewController {
    @objc func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        view.addSubview(navBar)
        navBar.items = [navBarItem]
        navBar.tintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
            UIColor.darkGray]
    }
}
