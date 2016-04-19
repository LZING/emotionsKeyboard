//
//  LZEmoticonModel.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

class LZEmoticonModel: NSObject, NSCoding{
    ///  模型所在文件夹
    var id : String
    ///  emoji 的16进制字符串
    var code : String? {
        didSet {
            // 转成emoji
            let scanner = NSScanner(string: code!)
            var result : UInt32 = 0
            scanner.scanHexInt(&result)
            // 设置表情图片
            emoji = String(Character(UnicodeScalar(result)))
        }
    }
    /// emoji表情
    var emoji : String?
    ///  表情名称, 用于网络传输
    var chs : String?
    ///  表情图片
    var png : String? {
        didSet {
            /// 拼接路径
            fullPngPath = LZEmoticonPackageManager.bundlePath + "/" + id + "/" + png!
        }
    }
    ///  表情路径
    var fullPngPath : String?
    // 字典转模型
    init(id : String, dict : [String : String]) {
        self.id = id
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description : String {
        return "\n \t 表情模型:code: \(code), emoji: \(emoji), chs: \(chs), png: \(png), fullPngPath: \(fullPngPath)"
    }
    
    //MARK: - decode&encode
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(emoji, forKey: "emoji")
        aCoder.encodeObject(chs, forKey: "chs")
        aCoder.encodeObject(png, forKey: "png")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as! String
        code = aDecoder.decodeObjectForKey("code") as? String
        emoji = aDecoder.decodeObjectForKey("emoji") as? String
        chs = aDecoder.decodeObjectForKey("chs") as? String
        png = aDecoder.decodeObjectForKey("png") as? String
        // 重新拼接路径
        if let p = png {
            fullPngPath = LZEmoticonPackageManager.bundlePath + "/" + id + "/" + p
        }
    }
}
