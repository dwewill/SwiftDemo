//
//  DWZNavigationBar.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/5/2.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZNavigationBar: UINavigationBar {


    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            var frame = self.frame
            frame.size.height = navigationHeight
            self.frame = frame
            for view in self.subviews {
                if String(describing: type(of: view)).contains("Background") {
                    view.frame = bounds
                }else if String(describing: type(of: view)).contains("ContentView") {
                    var frame = view.frame
                    frame.origin.y = statusBarHeight
                    frame.size.height = bounds.height-statusBarHeight
                    view.frame = frame
                }
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
