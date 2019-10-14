//
//  DWZWebViewController.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/10/14.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZWebViewController: DWZBaseViewController {
    
    let webView = UIWebView(frame: screen.bounds)
    
    var url: String? {
        didSet {
            guard let urlString = url ,
                  let requestUrl = URL(string: urlString) else {
                return
            }
            webView.loadRequest(URLRequest(url: requestUrl))
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupTableView() {
        title = "网页"
        view.insertSubview(webView, belowSubview: navBar)
        
    }

}
