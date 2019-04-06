//
//  DWZOAuthViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/4.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit
import SVProgressHUD

class DWZOAuthViewController: UIViewController {

    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.backgroundColor = UIColor.white
        webView.scrollView.isScrollEnabled = false
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
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '15889433219';"+"document.getElementById('passwd').value = 'dwz123456789';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
}


// MARK: - UIWebViewDelegate
extension DWZOAuthViewController: UIWebViewDelegate {
    
    /// web将要加载
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 请求
    ///   - navigationType: 导航栏类型
    /// - Returns: 是否加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        // 判断是否URL中包含百度的URL
        if let res = request.url?.absoluteString.hasPrefix(DWZRedirectURI), res == true {
            // 判断是否授权成功
            if request.url?.query?.contains("code") == true {
                let codeString = String(request.url?.absoluteString.split(separator: "=").last ?? "")
                print("授权码 -- \(codeString)")
                DWZNetworkManager.shared.requestAccessToken(authCode: codeString) { (json, isSuccess) in
                    print("isSuccess:\(isSuccess)  json:\(json ?? [:])")
                    if isSuccess {
                        NotificationCenter.default.post(name: NSNotification.Name(DWZUserLoginSuccessNotification), object: nil)
                    }else {
                        SVProgressHUD.showInfo(withStatus: "网络请求失败")
                    }
                    self.close()
                }
            }else if request.url?.query?.contains("code") == false{
                close()
            }
            return false
        }
        print("正常跳转 -- \(request.url?.absoluteString ?? "")")
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
