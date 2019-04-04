//
//  DWZOAuthViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/4.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZOAuthViewController: UIViewController {

    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 14, action: self, selector: #selector(close), isBack: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension DWZOAuthViewController {
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
