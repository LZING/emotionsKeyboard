//
//  LZEmoticonPackageModel.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

class LZEmoticonPackageModel: NSObject {
    ///  表情包文件夹名称
    var id : String
    ///  表情包名称
    var group_name_cn : String
    ///  所有表情模型
    private var emoticons : [LZEmoticonModel]
    ///  表情包所有页数据
    var pageEmoticons : [[LZEmoticonModel]] = [[LZEmoticonModel]]()
    ///  构造函数
    init(id : String, group_name_cn : String, emoticons : [LZEmoticonModel]) {
        self.id = id
        self.group_name_cn = group_name_cn
        self.emoticons = emoticons
        super.init()
        /// 将模型数组拆分成多页
        splitEmoticons()
    }
    
    /// 将模型数组拆分成多页
    private func splitEmoticons() {
        // 计算总页数
        let pageCount = (emoticons.count + LZEmoticonNumberOfPage - 1) / LZEmoticonNumberOfPage
        // 如果一页表情都没有
        if pageCount == 0 {
            // 创建一页空的表情
            let emptyEmoticon = [LZEmoticonModel]()
            pageEmoticons.append(emptyEmoticon)
            return
        }
        // 遍历,拆分每一页
        for i in 0..<pageCount {
            let location = i * LZEmoticonNumberOfPage
            // 判断最后一页截取的长度是否越界
            var length = LZEmoticonNumberOfPage
            // 当最后页的起始值+每页的数量 > 表情总数,说明会越界
            if location + LZEmoticonNumberOfPage > emoticons.count {
                length = emoticons.count - location
            }
            // 计算出一页表情范围
            let range = NSRange(location: location, length: length)
            // 一页表情
            let splitEmoticons = (emoticons as NSArray).subarrayWithRange(range) as! [LZEmoticonModel]
            pageEmoticons.append(splitEmoticons)
        }
    }
    
    override var description : String {
        return "\n \t 表情包模型:id: \(id), group_name_cn : \(group_name_cn), emoticons : \(emoticons)"
    }
}
