//
//  DWZStatusViewModel.swift
//  swiftDemo
//
//  Created by 段文拯 on 2019/4/8.
//  Copyright © 2019 段文拯. All rights reserved.
//

import UIKit

class DWZStatusViewModel: CustomStringConvertible {
    
    var status: DWZStatus
    
    init(status: DWZStatus) {
        self.status = status
    }
    
    var description: String {
        return status.yy_modelDescription()
    }
    
}
