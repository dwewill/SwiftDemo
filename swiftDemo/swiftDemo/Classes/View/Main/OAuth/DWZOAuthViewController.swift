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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", action: self, selector: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(DWZAppKey)&redirect_uri=\(DWZRedirectURI)"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
    

}

extension DWZOAuthViewController {
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '15889433219';"+"document.getElementById('passwd').value = 'dwz123456789';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
}


// MARK: - UIWebViewDelegate
extension DWZOAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if let res = request.url?.absoluteString.hasPrefix("http\\:www.baidu.com"), res == true {
            print("授权成功 -- \(request.url?.absoluteString ?? "")")
            return false
        }
        return true
    }
}
