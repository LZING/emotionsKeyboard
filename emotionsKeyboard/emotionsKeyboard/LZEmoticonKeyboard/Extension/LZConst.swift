//
//  LZConst.swift
//  Weibo
//
//  Created by lzing on 16/3/21.
//  Copyright © 2016年 lzing. All rights reserved.
//

import UIKit

/// 自定义Log,需要在build settings 里面搜索 preprocessor Macros (OC的配置方式), 在搜索 swift flag 配置debug "-D" "DEBUG"
func LZPrint(file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__, msg: Any) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)行], \(function): \(msg)")
    #endif
}

 /// 默认动画时间
let LZDefaultDuration : NSTimeInterval = 0.25

 /// appID
let client_id = "1823727905"

 /// 回调url
let redirect_uri = "http://www.baidu.com"

/// client_secret
let client_secret = "785e33f4b711a64697c01f724456037f"

/// 写在类外面,全局都可以用
let LZBaseURL = NSURL(string: "https://api.weibo.com/")

/// 新特性界面个数
let LZNewFeatureCount = 4

/// 间距
let LZStatusCellMargin:CGFloat = 8

/// 默认字体
let LZStatusCellDefaultFont : CGFloat = 11

/// 内容大小
let LZStatusCellContentSize : CGFloat = 14

/// 配图之间的间距
let LZStatusPictureMargin: CGFloat = 10

/// 最大配图数
let LZStatusPictureMaxColumn = 3

///  配图大小
let LZStatusPictureCellWH = (UIScreen.width - 2 * LZStatusCellMargin - CGFloat(LZStatusPictureMaxColumn - 1) * LZStatusPictureMargin) / CGFloat(LZStatusPictureMaxColumn)
