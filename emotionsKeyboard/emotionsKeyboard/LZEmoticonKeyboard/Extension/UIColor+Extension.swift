//
//  LZEmoticonKeyboard.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

extension UIColor {
    class func random() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    
    /**
     随机一个0-1之间的值
     
     - returns: 0-1之间的值
     */
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255.0
    }
}
