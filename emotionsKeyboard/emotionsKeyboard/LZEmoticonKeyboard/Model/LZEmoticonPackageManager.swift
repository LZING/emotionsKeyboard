//
//  LZEmoticonPackageManager.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

/// 一页显示20个表情
let LZEmoticonNumberOfPage : Int = 20

/// 一页有7列
let LZEmoticonColumnOfPage : Int = 7

/// 一页有3行
let LZEmoticonRowOfPage : Int = 3

/// 管理所有表情,加载/保存表情包和表情
class LZEmoticonPackageManager: NSObject {
    /// 单例
    static let sharedEmoticonPackageManager = LZEmoticonPackageManager()
    
    ///  解档与归档路径
    let emoticonsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/emoticons.plist")
    
    ///  获取Emoticons.bundle位置
    static let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)!
    
    private override init() {
        super.init()
    }
    
    ///  添加最近点击的表情
    func addFavourite(emoticon : LZEmoticonModel) {
        // 获取到最近这页表情模型位置
        var recentEmoticons = packages[0].pageEmoticons[0]
        // 获取之前已经存在表情(和传入的表情是重复的)
        let sameEmoticons = recentEmoticons.filter { (emoticonModel) -> Bool in
            if emoticon.emoji != nil {
                return emoticon.code == emoticonModel.code
            } else {
                return emoticon.chs == emoticonModel.chs
            }
        }
        // 将重复的表情删除
        if let sameEmoticon = sameEmoticons.first {
            // 获取重复表情的位置
            let index = recentEmoticons.indexOf(sameEmoticon)
            recentEmoticons.removeAtIndex(index!)
        }
        // 添加表情
        recentEmoticons.insert(emoticon, atIndex: 0)
        // 判断是否超过20,如果超过20,将数组最后的表情删除
        while recentEmoticons.count > LZEmoticonNumberOfPage {
            recentEmoticons.removeLast()
        }
        // 重新赋值
        packages[0].pageEmoticons[0] = recentEmoticons
        // 保存最近表情
        saveRecentEmoticons(packages[0].pageEmoticons[0])
    }
    
    ///  懒加载所有表情包模型
    lazy var packages : [LZEmoticonPackageModel] = self.loadPackage()
    
    ///  加载所有的表情包模型
    private func loadPackage() -> [LZEmoticonPackageModel] {
        var packages = [LZEmoticonPackageModel]()
        // 手动创建最近表情包
        let recentPackage = LZEmoticonPackageModel(id: "", group_name_cn: "最近", emoticons: loadRecentEmoticons())
        packages.append(recentPackage)
        // 加载默认表情包
        packages.append(loadPackage("com.sina.default"))
        // 加载emoji表情包
        packages.append(loadPackage("com.apple.emoji"))
        // 加载lxh表情包
        packages.append(loadPackage("com.sina.lxh"))
        return packages
    }
    
    ///  加载单个表情包
    private func loadPackage(id : String) -> LZEmoticonPackageModel {
        ///  加载文件夹的info.plist
        let infoPath = LZEmoticonPackageManager.bundlePath + "/" + id + "/" + "info.plist"
        // 读取plist中的字典
        let infoDict = NSDictionary(contentsOfFile: infoPath)!
        // 解析info.plist
        let group_name_cn = infoDict["group_name_cn"] as! String
        // 解析emoticons
        let emoticonsArray = infoDict["emoticons"] as! [[String : String]]
        // 定义表情模型数组
        var emoticons = [LZEmoticonModel]()
        // 遍历数组,拿出字典转模型
        for dict in emoticonsArray {
            emoticons.append(LZEmoticonModel(id : id, dict: dict))
        }
        return LZEmoticonPackageModel(id: id, group_name_cn: group_name_cn, emoticons: emoticons)
    }
    
    //MARK: - load&&save
    ///  加载最近表情
    private func loadRecentEmoticons() -> [LZEmoticonModel] {
        if let emoticons = NSKeyedUnarchiver.unarchiveObjectWithFile(emoticonsPath) as? [LZEmoticonModel]{
            return emoticons
        } else {
            return [LZEmoticonModel]()
        }
    }
    
    ///  保存最近表情
    private func saveRecentEmoticons(emoticons : [LZEmoticonModel]) {
        NSKeyedArchiver.archiveRootObject(emoticons, toFile: emoticonsPath)
    }
}
