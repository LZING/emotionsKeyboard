//
//  LZEmoticonToolBar.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

///  定义协议
protocol LZEmoticonToolBarDelegate : NSObjectProtocol {
    ///  toolbar按钮点击方法
    func emotionToolBar(toolBar : LZEmoticonToolBar, didSelectType type : LZEmoticonToolBarButtonType)
}

///  按钮tag对应的枚举
///
///  - Recent:  最近
///  - Default: 默认
///  - Emoji:   emoji
///  - Lxh:     浪小花
enum LZEmoticonToolBarButtonType : Int {
    case Recent = 0
    case Default = 1
    case Emoji = 2
    case Lxh = 3
}

class LZEmoticonToolBar: UIView {
    //MARK: - attribute
    ///  代理方法
    weak var delegate : LZEmoticonToolBarDelegate?
    ///  选中按钮
    private var selectedButton : UIButton?
    ///  加载xib方法
    class func emotionToolBar() -> LZEmoticonToolBar {
        return NSBundle.mainBundle().loadNibNamed("LZEmoticonToolBar", owner: nil, options: nil).last as! LZEmoticonToolBar
    }
    
    //MARK: - buttonClickAction
    @IBAction func toolBarButtonDidClick(button: UIButton) {
        // 切换选中按钮
        switchSelectedButton(button)
        // 调用代理方法
        let type = LZEmoticonToolBarButtonType(rawValue: button.tag)!
        delegate?.emotionToolBar(self, didSelectType: type)
    }
    
    // 选中某个按钮
    func switchSelectedButtonWithSection(section : Int) {
        // 找到对应按钮
        let button = self.subviews[section] as! UIButton
        // 切换按钮
        switchSelectedButton(button)
    }
    
    ///  切换按钮
    private func switchSelectedButton(button : UIButton) {
        // 如果选中的是同一个按钮则不再选中
        if selectedButton == button {
            return
        }
        // 取消上一个按钮的选中
        selectedButton?.selected = false
        // 选中当前按钮
        button.selected = true
        // 将当前按钮设置为上一个按钮
        selectedButton = button
    }
}
