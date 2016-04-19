//
//  ViewController.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emoticonKeyboard.textView = textView
        textView.inputView = emoticonKeyboard
        
        textView.becomeFirstResponder()
    }

    @IBAction func buttonDidClick(sender: AnyObject) {
        var result = ""
        textView.attributedText.enumerateAttributesInRange(NSRange(location: 0, length: textView.attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            // 如果dict中有NSAttachment标示是附件
            if let attachment = dict["NSAttachment"] as? LZTextAttachment {
                result += attachment.chs!
            } else {
                // 普通文本和emoji
                let subString = (self.textView.attributedText.string as NSString).substringWithRange(range)
                result += subString
            }
        }
        print("最终字符串: \(result)")
    }
    
    /// 表情键盘
    private lazy var emoticonKeyboard : LZEmoticonKeyboard = LZEmoticonKeyboard()
}

