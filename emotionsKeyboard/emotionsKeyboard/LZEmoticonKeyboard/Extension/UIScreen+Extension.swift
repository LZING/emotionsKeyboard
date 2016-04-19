//
//  LZEmoticonKeyboard.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// 只读计算型属性
    class var width: CGFloat {
        get {   // 加 class get会变成类方法
            return UIScreen.mainScreen().bounds.width
        }
    }
    
    /// 只读计算型属性
    class var height: CGFloat {
        get {
            return UIScreen.mainScreen().bounds.height
        }
    }
}
