//
//  LZEmoticonButton.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/4/2.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

class LZEmoticonButton: UIButton {

    var emoticon : LZEmoticonModel? {
        didSet {
            // 有emoji表情
            if emoticon!.emoji != nil {
                // 设置emoji表情
                self.setTitle(emoticon!.emoji, forState: UIControlState.Normal)
                // 清空图片表情
                self.setImage(nil, forState: UIControlState.Normal)
            } else { // 有图片
                // 清空emoji
                self.setTitle(nil, forState: UIControlState.Normal)
                // 设置表情图片
                self.setImage(UIImage(named: emoticon!.fullPngPath!), forState: UIControlState.Normal)
            }
        }
    }
}
